Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab2KCQmm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 12:42:42 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37310 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab2KCQmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 12:42:40 -0400
Date: Sat, 3 Nov 2012 16:42:23 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Eric Paris <eparis@parisplace.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Josh Boyer <jwboyer@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121103164223.GA30843@srcf.ucam.org>
References: <20121101215817.79e50ec2@pyramind.ukuu.org.uk>
 <20121101215752.GA21154@srcf.ucam.org>
 <87625ogzje.fsf@xmission.com>
 <20121102140057.GA4668@srcf.ucam.org>
 <87liejacix.fsf@xmission.com>
 <20121103002033.GA18691@srcf.ucam.org>
 <87sj8rwm0p.fsf@xmission.com>
 <20121103014332.GA20065@srcf.ucam.org>
 <20121103163152.1405e2cb@pyramind.ukuu.org.uk>
 <CACLa4pt3_Fc5fHKf=ihzV0zDb7zvCyzWp92YLakjGqL7MCaiEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACLa4pt3_Fc5fHKf=ihzV0zDb7zvCyzWp92YLakjGqL7MCaiEA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2012 at 12:37:44PM -0400, Eric Paris wrote:
> On Sat, Nov 3, 2012 at 12:31 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> You're guaranteed to be able
> >> to do this on any Windows 8 certified hardware.
> >
> > Thats not my understanding of the situation.
> 
> Windows 8 certification has this as a requirement for x86 hardware.  I
> belied the opposite is a requirement for arm hardware.  However it's
> possible that it just doesn't specifiy at all for arm.

Arm devices are Windows RT, not Windows 8.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
