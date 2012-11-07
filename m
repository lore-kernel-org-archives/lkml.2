Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2KGO4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:56:05 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:60593 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab2KGO4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:56:02 -0500
Date: Wed, 7 Nov 2012 14:55:19 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Olivier Galibert <galibert@pobox.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Florian Weimer <fw@deneb.enyo.de>,
        Chris Friesen <chris.friesen@genband.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Eric Paris <eparis@parisplace.org>,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121107145518.GB30662@srcf.ucam.org>
References: <87fw4nv1vj.fsf@xmission.com>
 <20121106035352.GA24698@srcf.ucam.org>
 <87hap3s3yl.fsf@xmission.com>
 <878vafqi5q.fsf@mid.deneb.enyo.de>
 <50992946.4060101@genband.com>
 <87625iwgao.fsf@mid.deneb.enyo.de>
 <7c6b2e83-e49a-40aa-a990-da7599622f37@email.android.com>
 <20121106224920.3b9d4a86@pyramind.ukuu.org.uk>
 <a35e035b-de9d-4253-9e7d-ae1f1c2e2f88@email.android.com>
 <CAMFK0gt7oAr4ArD8FmD8QE+i4g4rSTmQjbbLcjs02xwQeXGx-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMFK0gt7oAr4ArD8FmD8QE+i4g4rSTmQjbbLcjs02xwQeXGx-A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 09:19:35AM +0100, Olivier Galibert wrote:
> On Tue, Nov 6, 2012 at 11:47 PM, Matthew Garrett <mjg59@srcf.ucam.org>wrote:
> 
> > Sure, and scripts run as root can wipe your files too. That's really not
> > what this is all about.
> 
> What it is about then? What is secure boot supposed to do for the owner of
> the computer in a linux context?  I've not been able to understand it
> through this discussion.

It provides a chain of trust that allows you to ensure that a platform 
boots a trusted kernel. That's a pre-requisite for implementing any kind 
of fully trusted platform, but it's not sufficient in itself. One of 
those additional requirements is ensuring that the kernel *stays* 
trusted - in the past an attacker could just replace the kernel on disk 
and so there was little incentive to engage in more subtle attacks, but 
now that's impossible we need to care about them.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
