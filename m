Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab2DCF43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 01:56:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50849 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab2DCF42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 01:56:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: venom00 <venom00@setsun.org>
Subject: Re: [s2disk] Inappropriate ioctl on /dev/snapshot
Date: Tue, 3 Apr 2012 08:00:49 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
References: <EV0ByeH8JeDWvk23_hS3M1XIjq7ZqojHm-IJJdI6CcZXMuZdq2gOAlqCGWMX1UCTpf9qG5vgeUMtaBztXYzLkQ@localhost.localdomain> <20120402100625.GA1216@elf.ucw.cz> <9Jr6_fKFH8Umxxs-dQGSOyRp3KqouVJ5VXrBfs1lJmHEgv6ITSoG7dqJWPT6sPGR8h5aOXDJHpJMUxXb0X1vvw@localhost.localdomain>
In-Reply-To: <9Jr6_fKFH8Umxxs-dQGSOyRp3KqouVJ5VXrBfs1lJmHEgv6ITSoG7dqJWPT6sPGR8h5aOXDJHpJMUxXb0X1vvw@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204030800.49585.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 02, 2012, venom00 wrote:
> On Mon, 2012-04-02 at 12:06 +0200, Pavel Machek wrote:
> > 
> > Hi! If it worked on previous kernels, it is an  regression and
> > something for rjw to track.
> 
> It's my first try with Xen.
> 
> > By chance, are you using 32bit userland on 64bit kernel?
> 
> No.
> 
> > (Rafael: Did we remove some compatibility code, recently?) 
> 
> Sorry, I've updated suspend-1.0 and works fine ;)

OK, cool.

Thanks,
Rafael
