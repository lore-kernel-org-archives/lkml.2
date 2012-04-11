Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab2DKSF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:05:26 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:56828 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932777Ab2DKSFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:05:25 -0400
Date: Wed, 11 Apr 2012 14:05:20 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org, hjl.tools@gmail.com
Subject: Re: Trying to make a working kernel with the gold linker
Message-ID: <20120411180520.GE12044@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	linux-kernel@vger.kernel.org, hjl.tools@gmail.com
References: <E1SHnDZ-0006Za-Kh@tytso-glaptop.cam.corp.google.com>
 <20120411045107.GA324@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411045107.GA324@x4>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 06:51:07AM +0200, Markus Trippelsdorf wrote:
> 
> Yes. I use it regularly. The last problems were fixed two years ago.
> Please try a more recent version.

Thanks, I'll give that a try.  Next stupid question; for a variety of
reasons, the Corporate I/T folks require that I stay stuck on Ubuntu
10.04.  Are there any incompatibility problems with using the most
recently released binutils-gold and gcc 4.4.3-4ubuntu5.1?  Basically,
can I just compile a new version of binutils, or do I need to upgrade
my entire compiler toolchain?

Thanks,

						- Ted
