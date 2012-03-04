Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab2CDBlf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 20:41:35 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:51447 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069Ab2CDBlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 20:41:35 -0500
Date: Sat, 3 Mar 2012 20:41:23 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        "John G. Heim" <jheim@math.wisc.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: speakup bug
Message-ID: <20120304014122.GA4333@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"John G. Heim" <jheim@math.wisc.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <BFFDBC9B6BA14BE1AC8E266A3A456A63@hinkle>
 <20120303173916.7eca9391@pyramind.ukuu.org.uk>
 <FD8CB954D8084F998E24C4558E41C627@hinkle>
 <20120304001806.GO4180@type.famille.thibault.fr>
 <20120304002111.GP4180@type.famille.thibault.fr>
 <20120304004116.GA3042@thunk.org>
 <20120304004348.GR4180@type.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120304004348.GR4180@type.famille.thibault.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2012 at 01:43:48AM +0100, Samuel Thibault wrote:
> 
> Sure!  But there should be a way to do it without /, just like the
> serial console works on ttyUSB0 without /.

It's not impossible, but the hard part will be creating a naming
infrastructure so the user can specify the appropriate serial port if
there are multiple (non-console) tty devices present on the system.

My suggestion would be to get it working using a userspace daemon, and
then putting in the kernel code to open the serial port without a file
system.  It certainly can be done, with roughly the same techniques
that are used to mount the root file system in the non-initrd case.

     	      	       	   	     - Ted
