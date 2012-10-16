Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab2JPQrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:47:36 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:33165 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab2JPQrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:47:35 -0400
Message-ID: <1350406050.2785.18.camel@lorien2>
Subject: Re: [PATCH 1/1] x86, e820: Remove direct mapping of reserved space
 for HT hole around 1TB
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Jacob Shin <jacob.shin@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>, shuahkhan@gmail.com
Date: Tue, 16 Oct 2012 10:47:30 -0600
In-Reply-To: <1318370975-10817-1-git-send-email-jacob.shin@amd.com>
References: <1318370975-10817-1-git-send-email-jacob.shin@amd.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacob,

On Tue, 2011-10-11 at 17:09 -0500, Jacob Shin wrote:
> The entire HT hole and also the unused address range before that hole
> need to be excluded from direct mapping. Otherwise speculative
> accesses to that reserved region can happen which cause machine
> checks.

Has the HT support even been added? I have a system with HT memory
histing feature and I am unable to boot with 1TB. Has this work been
redone as discussed in this thread?

-- Shuah


