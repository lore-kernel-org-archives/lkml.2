Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763274Ab2KCBnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 21:43:55 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43302 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab2KCBnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 21:43:53 -0400
Date: Sat, 3 Nov 2012 01:43:32 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121103014332.GA20065@srcf.ucam.org>
References: <20121101212843.GA20309@srcf.ucam.org>
 <20121101213751.377ebaa8@pyramind.ukuu.org.uk>
 <20121101213452.GA20564@srcf.ucam.org>
 <20121101215817.79e50ec2@pyramind.ukuu.org.uk>
 <20121101215752.GA21154@srcf.ucam.org>
 <87625ogzje.fsf@xmission.com>
 <20121102140057.GA4668@srcf.ucam.org>
 <87liejacix.fsf@xmission.com>
 <20121103002033.GA18691@srcf.ucam.org>
 <87sj8rwm0p.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sj8rwm0p.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 05:47:02PM -0700, Eric W. Biederman wrote:

> No reason to?  How can I configure an off the shelf system originally
> sold with windows 8 installed to boot in UEFI secure boot mode using
> shim without trusting Microsoft's key?

Delete the installed keys, install your choice of keys, make sure your 
bootloader is signed with a key you trust. You're guaranteed to be able 
to do this on any Windows 8 certified hardware.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
