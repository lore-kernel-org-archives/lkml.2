Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045Ab1DZWv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 18:51:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52805 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759000Ab1DZWv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 18:51:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=taBieIMVWyIV6D5a24HWBego28HFIdF4rIGRxEL/q81BRp/Wav6QIKHhCICAN10MKt
         gAYtmjmHwMnu2jJ8ekxg==
MIME-Version: 1.0
In-Reply-To: <BANLkTi=psQRm9W9uXBgCEyYp-oEA0d0GVA@mail.gmail.com>
References: <1303728272-11408-1-git-send-email-leemgs1@gmail.com>
	<1303728272-11408-4-git-send-email-leemgs1@gmail.com>
	<20110425084508.dda5ec8f.randy.dunlap@oracle.com>
	<BANLkTi=psQRm9W9uXBgCEyYp-oEA0d0GVA@mail.gmail.com>
Date: Tue, 26 Apr 2011 15:51:22 -0700
Message-ID: <BANLkTikVLj3W6dSNRERntjOcX0kh-wrJYg@mail.gmail.com>
Subject: Re: [PATCH 3/4] munmap: kbuild menu for munmap interface
From: Hugh Dickins <hughd@google.com>
To: Geunsik Lim <leemgs1@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 5:42 PM, Geunsik Lim <leemgs1@gmail.com> wrote:
> I will modify contents that you commented.

Thank you for making the effort, but we would much prefer to eliminate
ZAP_BLOCK_SIZE than have a configurable ZAP_BLOCK_SIZE.  So I don't
think you need update the contents here.

Peter's preemptible mmu_gather work is expected to be included in the
next mmotm.  Please test on that, and if it does not meet your needs,
do let us know.

Thanks,
Hugh
