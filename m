Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab2D3FGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 01:06:11 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65449 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab2D3FGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 01:06:00 -0400
Date: Sun, 29 Apr 2012 18:05:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Miller <davem@davemloft.net>
Cc: jrnieder@gmail.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, sam@ravnborg.org, mmarek@suse.cz
Subject: Re: [ 30/62] Fix modpost failures in fedora 17
Message-ID: <20120430010500.GC25022@kroah.com>
References: <20120424223305.GA7748@kroah.com>
 <20120424223244.539071890@linuxfoundation.org>
 <20120426004131.GA8556@burratino>
 <20120425.204817.1783721275395887649.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425.204817.1783721275395887649.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 08:48:17PM -0400, David Miller wrote:
> From: Jonathan Nieder <jrnieder@gmail.com>
> Date: Wed, 25 Apr 2012 19:41:32 -0500
> 
> > I haven't tested this, but I suspect 3.0.y has the same problem ---
> > v3.3-rc1~66^2~12 ("modpost: use a table rather than a giant if/else
> > statement") just clarified the code a little and does not seem to have
> > gone wrong.
> > 
> > In other words, the conflict encountered when applying this to 3.0.y
> > looks like a textual and not a meaningful one.  Backport follows.
> 
> This is %100 correct.

Great, now applied.
