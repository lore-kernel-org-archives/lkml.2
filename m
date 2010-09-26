Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab0IZAB7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 20:01:59 -0400
Received: from thunk.org ([69.25.196.29]:56571 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab0IZAB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 20:01:58 -0400
Date: Sat, 25 Sep 2010 20:01:54 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Christoph Hellwig <hch@lst.de>
Cc: T Dent <tdent48227@gmail.com>, adilger.kernel@dilger.ca, jack@suse.cz,
        dmonakhov@openvz.org, sandeen@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] Fs: ext4: acl.c: fixed indent issue
Message-ID: <20100926000154.GB5299@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>,
	T Dent <tdent48227@gmail.com>, adilger.kernel@dilger.ca,
	jack@suse.cz, dmonakhov@openvz.org, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
 <20100925233600.GA2854@lst.de>
 <AANLkTimf9Q=jfga=--H0VaZeWnbAVNhCPMn_G81sZ8vh@mail.gmail.com>
 <20100925235643.GA3224@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100925235643.GA3224@lst.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 01:56:43AM +0200, Christoph Hellwig wrote:
> On Sat, Sep 25, 2010 at 07:53:02PM -0400, T Dent wrote:
> > On 9/25/10, Christoph Hellwig <hch@lst.de> wrote:
> > > Please don't Cc me on ext4 patches, thanks.
> > >
> > Ok.. i just used the get maintainer script and your name was on it.
> > 
> 
> The script is broken but the maintainer refuses to fix it.

Wow, I just looked at how get_maintainer.pl works, and it's amazing
how broken it is.  I guess I had heard some rumblings of unhappiness
about it, but I'm surprised it's been allowed to live.

      	      	  	    	      	      - Ted

