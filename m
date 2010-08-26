Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0HZHCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 03:02:01 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37116 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752551Ab0HZHB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 03:01:59 -0400
Date: Thu, 26 Aug 2010 09:01:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: James Morris <jmorris@namei.org>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [AppArmor #7 0/13] AppArmor security module
Message-ID: <20100826070145.GA11959@elf.ucw.cz>
References: <1280440089-3203-1-git-send-email-john.johansen@canonical.com>
 <alpine.LRH.2.00.1007300903440.7719@tundra.namei.org>
 <20100805062431.GA1546@ucw.cz>
 <alpine.LRH.2.00.1008052023030.14772@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1008052023030.14772@tundra.namei.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-08-05 20:27:24, James Morris wrote:
> On Thu, 5 Aug 2010, Pavel Machek wrote:
> 
> > > Note that I added the patch below to update AA against the latest 
> > > version of path_truncate:
> > 
> > Ok, so now we have two name-based "security" modules. Can we at least
> > drop TOMOYO? That seems to have all apparmor disadvantages plus some
> > more...
> 
> No.  The policy is that any security module which implements an access 
> control scheme and meets a well-defined security goal, and passes 
> technical review, may be merged.
> 
> aka, The Arjan Protocol:
> 
> http://kerneltrap.org/Linux/Documenting_Security_Module_Intent

It seems that security subsystem has lower standards than rest of the
kernel. Sad.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
