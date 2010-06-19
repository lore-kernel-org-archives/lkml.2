Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab0FSRrK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 13:47:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:35876 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760Ab0FSRrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 13:47:05 -0400
Date: Sat, 19 Jun 2010 19:47:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Alan Ott <alan@signal11.us>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: [PATCH v2 0/2] HID: hidraw documentation
In-Reply-To: <20100618201445.28c58573.rdunlap@xenotime.net>
Message-ID: <alpine.LNX.2.00.1006191946030.13809@pobox.suse.cz>
References: <1276832283-12084-1-git-send-email-alan@signal11.us> <1276913623-6126-1-git-send-email-alan@signal11.us> <20100618201445.28c58573.rdunlap@xenotime.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jun 2010, Randy Dunlap wrote:

> On Fri, 18 Jun 2010 22:13:41 -0400 Alan Ott wrote:
> 
> > These patches add the hidraw.txt file to a new Documentation/hid/ directory.
> > 
> > The example program has been moved out of the document and fixed up for style
> > (it's now checkpatch.pl clean), and a Makefile has been created for it.
> > 
> > I integrated the comments provided.
> > 
> > hiddev.txt has been moved from Documentation/usb/ to Documentation/hid/
> > 
> > 
> > Alan Ott (2):
> >   HID: Documentation for hidraw
> >   HID: Move hiddev.txt to the new Documentation/HID directory
> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Jiri, can you merge these patches, please?

Yeah, I will be taking them through my tree, thanks.

I am only still waiting for Marcel (or any other Bluetooth people) to Ack 
the bluetooth-side of the HIDIOCGFEATURE/HIDIOCSFEATURE patch, so that the 
documentation actually tells the truth :)

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
