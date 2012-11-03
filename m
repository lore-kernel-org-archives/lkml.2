Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab2KCQiJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 12:38:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48896 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757457Ab2KCQhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 12:37:48 -0400
Date: Sat, 3 Nov 2012 16:37:27 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121103163726.GA30689@srcf.ucam.org>
References: <20121101213452.GA20564@srcf.ucam.org>
 <20121101215817.79e50ec2@pyramind.ukuu.org.uk>
 <20121101215752.GA21154@srcf.ucam.org>
 <87625ogzje.fsf@xmission.com>
 <20121102140057.GA4668@srcf.ucam.org>
 <87liejacix.fsf@xmission.com>
 <20121103002033.GA18691@srcf.ucam.org>
 <87sj8rwm0p.fsf@xmission.com>
 <20121103014332.GA20065@srcf.ucam.org>
 <20121103163152.1405e2cb@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121103163152.1405e2cb@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2012 at 04:31:52PM +0000, Alan Cox wrote:
> > You're guaranteed to be able 
> > to do this on any Windows 8 certified hardware.
> 
> Thats not my understanding of the situation.

"17. Mandatory. On non-ARM systems, the platform MUST implement the 
ability for a physically present user to select between two Secure Boot 
modes in firmware setup: "Custom" and "Standard". Custom Mode allows for 
more flexibility as specified in the following: 

a. It shall be possible for a physically present user to use the Custom 
Mode firmware setup option to modify the contents of the Secure Boot 
signature databases and the PK. This may be implemented by simply 
providing the option to clear all Secure Boot databases (PK, KEK, db, 
dbx), which puts the system into setup mode."

-- 
Matthew Garrett | mjg59@srcf.ucam.org
