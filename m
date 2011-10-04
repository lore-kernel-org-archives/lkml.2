Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab1JDTUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:20:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47680 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932916Ab1JDTUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:20:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: kernel.org status: establishing a PGP web of trust
Date: Tue, 4 Oct 2011 21:23:10 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: "Ted Ts'o" <tytso@mit.edu>, Josh Triplett <josh@joshtriplett.org>,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
References: <4E8655CD.90107@zytor.com> <20111004044914.GP6684@thunk.org> <4E8A910D.6020107@zytor.com>
In-Reply-To: <4E8A910D.6020107@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110042123.11017.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 04, 2011, H. Peter Anvin wrote:
> On 10/03/2011 09:49 PM, Ted Ts'o wrote:
> > 
> > Note that if your laptop allows incoming ssh connections, and you
> > logged into master.kernel.org with ssh forwarding enabled, your laptop
> > may not be safe.  So be very, very careful before you assume that your
> > laptop is safe.  At least one kernel developer, after he got past the
> > belief, "surely I could have never had my machine be compromised",
> > looked carefully and found rootkits on his machines.
> > 
> >        		     	   	       - Ted
> 
> By the way, I'm now pretty convinced that allowing inbound ssh on
> laptops (which is the default on all the mainline Linux distros as far
> as I know) is seriously broken... laptops get connected to *extremely*
> insecure networks on just way too regular a basis.

That's very true.

I'd recommend everyone to run a full nmap scan of his/her laptop
and to block everything it finds open before using it outside of the home
network.

Thanks,
Rafael
