Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab0DBRAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 13:00:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52352 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab0DBQ74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 12:59:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] what the patches do Re: [RFC 10/15] PM / Hibernate: user, implement user_ops reader
Date: Fri, 2 Apr 2010 19:03:12 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Nigel Cunningham <ncunningham@crca.org.au>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jslaby@suse.cz>, jirislaby@gmail.com,
       linux-pm@lists.linux-foundation.org
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <4BABDA59.8070107@crca.org.au> <20100402063644.GA14941@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20100402063644.GA14941@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004021903.12993.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 April 2010, Pavel Machek wrote:
...
> > Neither of those are impossible with in-kernel code, so I'd argue that  
> > there's no need to keep the s2disk interface long-term. Userspace  
> 
> I disagree.
> 
> > helpers might be necessary for the first one (to manage the network  
> > interface), but I already have multiple-resumes-from-the-same-image  
> > support in TuxOnice (and more 'crazy stuff' like support for resuming a  
> > different image after writing one - that can be used to switch to an  
> > initramfs containing the binaries needed to power down a UPS).
> 
> The fact that it can be done in kernel -- anything can -- but whether
> it should. I'd very much like to keep the 'crazy stuff' in userspace.

IMO the question really boils down to what's the benefit of doing these things
in the kernel vs doing them in the user space.

If doing them in the kernel reduces the overall complexity of design (including
the user space interface involved etc.) I don't really see why not to.

Rafael
