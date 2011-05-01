Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab1EAPSI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 11:18:08 -0400
Received: from kroah.org ([198.145.64.141]:57268 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372Ab1EAPSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 11:18:06 -0400
Date: Sat, 30 Apr 2011 19:39:53 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, randy.dunlap@oracle.com, joe@perches.com
Subject: Re: [Oops 1/2]Something wrong with copy_from_user() function
Message-ID: <20110501023953.GA30713@kroah.com>
References: <20110430061336.GA4274@gmail.com>
 <alpine.LNX.2.00.1104302311530.12035@pobox.suse.cz>
 <20110501012127.GA2378@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501012127.GA2378@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 09:21:30AM +0800, Harry Wei wrote:
> On Sat, Apr 30, 2011 at 11:13:10PM +0200, Jiri Kosina wrote:
> > On Sat, 30 Apr 2011, Harry Wei wrote:
> > 
> > 
> > wpa_set_keys() function (from staging drivers) in your kernel uses 
> > copy_from_user() without proper bounds checking, and thus can overflow and 
> > corrupt memory.
> Hmmm, i see.

Patches gladly welcome to fix this :)
