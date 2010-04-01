Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab0DAVuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 17:50:54 -0400
Received: from mail-pz0-f201.google.com ([209.85.222.201]:55527 "EHLO
	mail-pz0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab0DAVut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 17:50:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Gpj+p/atQQnMM0qoprssGrE7As1E15vET7VU0lJ5u89sILwCrIcyTm4NhloPXm6Jov
         R5+ra/InP0DwT7jgPU+40a/wpdbExA8uvAaDY4QSO1ciW0aTNAJ87kH9ycFLK46umkWW
         8MZtnvBCr2ik5zZQRRxGD09mpjG7S58huIiUA=
MIME-Version: 1.0
In-Reply-To: <20100301194109.GA10847@elte.hu>
References: <20100301194109.GA10847@elte.hu>
Date: Thu, 1 Apr 2010 14:50:48 -0700
X-Google-Sender-Auth: f584d8c561b6e4a8
Message-ID: <t2o12c511ca1004011450wf862bf81gcf714281be40ee4e@mail.gmail.com>
Subject: Re: [GIT PULL] "perf probe" updates, kprobes jump optimization, for 
	v2.6.34
From: Tony Luck <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 1, 2010 at 11:41 AM, Ingo Molnar <mingo@elte.hu> wrote:
> Please pull the latest perf-probes-for-linus git tree from:

Since this went in I'm seeing:

kernel/kprobes.c:719: warning: ‘arm_kprobe’ defined but not used

from the arch/ia64/configs/zx1_defconfig build on ia64

Looks to be because that config ends up with:

CONFIG_KPROBES=y

together with

# CONFIG_DEBUG_FS is not set

-Tony
