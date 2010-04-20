Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab0DTWOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 18:14:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50500 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab0DTWOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 18:14:32 -0400
Date: Tue, 20 Apr 2010 15:14:08 -0700
From: Greg KH <gregkh@suse.de>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: stefani@seibold.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, andi@firstfloor.org,
       alan@lxorguk.ukuu.org.uk, tytso@mit.edu
Subject: Re: [PATCH 0/4] enhanced reimplemention of the kfifo API
Message-ID: <20100420221408.GB2411@suse.de>
References: <1271794000-18897-1-git-send-email-stefani@seibold.net>
 <20100420201642.GA32373@suse.de>
 <20100420204258.GK7651@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100420204258.GK7651@ovro.caltech.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 01:42:58PM -0700, Ira W. Snyder wrote:
> Unfortunately, my drivers are not upstream, as they're for very custom
> hardware, and would not be useful on anything outside of my lab. I'm
> happy to send the source to anyone interested.

Drivers with only one user are gladly accepted into the kernel tree, so
feel free to submit them.

Especially if you start to take advantage of this abi, we want to know
who uses it so it isn't deleted in the future :)

thanks,

greg k-h
