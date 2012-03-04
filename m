Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab2CDA1B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 19:27:01 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:58899 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab2CDA1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 19:27:00 -0500
Date: Sat, 3 Mar 2012 19:26:55 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: "John G. Heim" <jheim@math.wisc.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: speakup bug
Message-ID: <20120304002655.GE6117@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"John G. Heim" <jheim@math.wisc.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <BFFDBC9B6BA14BE1AC8E266A3A456A63@hinkle>
 <20120303173916.7eca9391@pyramind.ukuu.org.uk>
 <FD8CB954D8084F998E24C4558E41C627@hinkle>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FD8CB954D8084F998E24C4558E41C627@hinkle>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2012 at 06:01:07PM -0600, John G. Heim wrote:
> 
> Do you recall if they gave a reason for not wanting to use the serial layer?
> I don't even know what the serial layer is (although the name is descriptive
> enough and I can guess).But I would think they'd have had some reason for
> not wanting to do that.

Looking at the code, I'm going to guess that it's largely historical.
I'd guess that original core code was originally written for MS-DOS
(main.c?  RLY?), and once they got it working, they never went back to
fix things.  Even if it wasn't the most efficient way to do things, I
suspect most of the blind community didn't care once it was working
--- and they probably didn't have anyone who really understood the tty
line discpline layer, since it wasn't very well documented.

	  	       	  	      - Ted
