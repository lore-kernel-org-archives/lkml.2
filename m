Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab0ERHAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 03:00:16 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56089 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab0ERHAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 03:00:13 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
References: <20100518164520.7e9652b1.sfr@canb.auug.org.au>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 18 May 2010 00:00:01 -0700
In-Reply-To: <20100518164520.7e9652b1.sfr@canb.auug.org.au> (Stephen Rothwell's message of "Tue\, 18 May 2010 16\:45\:20 +1000")
Message-ID: <m1wrv13dam.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: sfr@canb.auug.org.au, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, greg@kroah.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Rothwell <sfr@canb.auug.org.au>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: linux-next: build failure after merge of the driver-core tree
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Greg,
>
> After merging the driver-core tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> fs/sysfs/mount.c: In function 'sysfs_exit_ns':
> fs/sysfs/mount.c:160: error: 'S_BIAS' undeclared (first use in this function)
>
> Caused by commit c80e63f000aa7cf73a430b2cb57dbbb91554a847 ("sysfs:
> Implement sysfs tagged directory support") from the driver-core tree
> interacting with commit f3ffc7acb6a6ebec0a9e660d9211ed048d7e90f5 ("get
> rid of S_BIAS") from the vfs tree.
>
> I don't know how to fix this, so I just commented the code out for now
> (see below). Please someone supply a correct fix.
>
> [Al, I notice that the "get rid of S_BIAS" patch has an author date of
> March 22 - it would have been nice if it had been in linux-next during
> the last two months so that we could have had a fix for this some time
> ago.]

Stephen what is the easiest way to get a copy of Al's tree so I can take
a look to see what needs to happen?

Eric
