Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab2DKEvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 00:51:12 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:52823 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab2DKEvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 00:51:11 -0400
Date: Wed, 11 Apr 2012 06:51:07 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, hjl.tools@gmail.com
Subject: Re: Trying to make a working kernel with the gold linker
Message-ID: <20120411045107.GA324@x4>
References: <E1SHnDZ-0006Za-Kh@tytso-glaptop.cam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1SHnDZ-0006Za-Kh@tytso-glaptop.cam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.04.10 at 22:23 -0400, Theodore Ts'o wrote:
> 
> So I was trying to see if I could make the kernel build with the gold
> linker (since until it can, I can't install it on my system).
> 
> I saw a message from HJ indicating one of the problems was x86_64 gold
> used an incompatible max-page-size setting, so I tried changing it in
> hopes that would make a bootable kernel.
> 
> No dice, it didn't work.  (At least not with a 2.20 binutils-gold.)
> 
> Does anybody know what the other issues with the gold linker?  Is the
> 2.22 binutils-gold more likely to work?

Yes. I use it regularly. The last problems were fixed two years ago.
Please try a more recent version.

-- 
Markus
