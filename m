Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab2KFFfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 00:35:18 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:38639 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab2KFFfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 00:35:16 -0500
Date: Tue, 6 Nov 2012 05:34:46 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121106053446.GA25697@srcf.ucam.org>
References: <509766DB.9090906@zytor.com>
 <87625kh5r2.fsf@xmission.com>
 <20121105123858.GB4374@srcf.ucam.org>
 <87sj8nc137.fsf@xmission.com>
 <20121105202557.GA16076@srcf.ucam.org>
 <87hap3zbw7.fsf@xmission.com>
 <20121106031219.GB24235@srcf.ucam.org>
 <87fw4nv1vj.fsf@xmission.com>
 <20121106035352.GA24698@srcf.ucam.org>
 <87hap3s3yl.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hap3s3yl.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 09:19:46PM -0800, Eric W. Biederman wrote:
> Matthew Garrett <mjg59@srcf.ucam.org> writes:
> 
> > On Mon, Nov 05, 2012 at 07:36:32PM -0800, Eric W. Biederman wrote:
> >
> >> For automated installs you don't have to satisfy me.  Feel free to
> >> deliver a lousy solution to your users.   Just don't use your arbitrary
> >> design decisions to justify your kernel patches.
> >
> > My kernel patches are justified by genuine user requirements. 
> 
> Hogwash.

You keep using that word, which is unfortunate.

> If windows is not present on a system linux can not be used to boot a
> compromised version of windows without user knowledge because windows is
> not present.

Correct.

> If windows is present on a system then to install linux a user must be
> present and push buttons to get the system to boot off of install media.

Incorrect. UEFI boot priorities can be set without physical user 
interaction.

> If a user is present a user presence test may be used to prevent a
> bootloader signed with  Microsoft's key from booting linux without the
> users consent, and thus prevent Linux from attacking windows users.

Correct, but precludes the kind of automated installs that I know real 
people do. The keys a machine carries don't vary depending on whether it 
shipped with Windows or not, so it's not possible to differentiate 
between the "shipped with Windows" and "shipped without Windows" cases 
when determining security models.

> Therefore preventing the revokation of a signature with Microsoft's
> signature from your bootloader does not justify elaborate kernel
> modifications to prevent the booting a compromised version of windows.

That's a stretch.

Bored now. You're adding nothing new to anyone's understanding of the 
problem, and I'm just saying the same thing I've been saying for months, 
so I don't see any purpose in discussing this with you further.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
