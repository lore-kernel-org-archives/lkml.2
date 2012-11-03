Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762064Ab2KCAU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 20:20:58 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60065 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2KCAU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 20:20:56 -0400
Date: Sat, 3 Nov 2012 00:20:34 +0000
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
Message-ID: <20121103002033.GA18691@srcf.ucam.org>
References: <20121101210634.GA19723@srcf.ucam.org>
 <20121101213127.5967327f@pyramind.ukuu.org.uk>
 <20121101212843.GA20309@srcf.ucam.org>
 <20121101213751.377ebaa8@pyramind.ukuu.org.uk>
 <20121101213452.GA20564@srcf.ucam.org>
 <20121101215817.79e50ec2@pyramind.ukuu.org.uk>
 <20121101215752.GA21154@srcf.ucam.org>
 <87625ogzje.fsf@xmission.com>
 <20121102140057.GA4668@srcf.ucam.org>
 <87liejacix.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87liejacix.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 03:03:02PM -0700, Eric W. Biederman wrote:

> I don't want my system p0wned in the first place and I don't want to run
> windows.  Why should I trust Microsoft's signing key?

There's no reason to. Systems that don't trust Microsoft's signing key 
have no reason to be concerned about Microsoft revocation. 
Unfortunately, that's not the only set of people we have to worry about.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
