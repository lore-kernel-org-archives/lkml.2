Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab2GFXCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 19:02:25 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:50202 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab2GFXCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 19:02:23 -0400
Date: Fri, 6 Jul 2012 18:02:18 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        ewust@umich.edu, zakir@umich.edu, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 05/12] usb: feed USB device information to the
 /dev/random driver
Message-ID: <20120706230218.GD3728@burratino>
References: <1341614704-24965-1-git-send-email-tytso@mit.edu>
 <1341614704-24965-6-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341614704-24965-6-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Theodore Ts'o wrote:

> Send the USB device's serial, product, and manufacturer strings to the
> /dev/random driver to help seed its pools.
>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Acked-by: Greg KH <greg@kroah.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: stable@vger.kernel.org

Why cc: stable@?  Does this fix a build error, oops, hang, data
corruption, real security issue, or other critical "oh, that's not
good" bug?

(I can imagine some reasons but I'm asking because it's not spelled
out.)

Thanks,
Jonathan
