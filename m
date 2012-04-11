Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991Ab2DKTNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:13:31 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:49273 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932889Ab2DKTNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:13:30 -0400
Date: Wed, 11 Apr 2012 15:13:25 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org, hjl.tools@gmail.com
Subject: Re: Trying to make a working kernel with the gold linker
Message-ID: <20120411191325.GL12044@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	linux-kernel@vger.kernel.org, hjl.tools@gmail.com
References: <E1SHnDZ-0006Za-Kh@tytso-glaptop.cam.corp.google.com>
 <20120411045107.GA324@x4>
 <20120411180520.GE12044@thunk.org>
 <20120411182856.GA327@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411182856.GA327@x4>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 08:28:56PM +0200, Markus Trippelsdorf wrote:
> 
> Just compiling and installing a new binutils version should work fine.
> 
> (But you should nonetheless consider to also upgrade gcc, because
> gcc-4.4 is ancient and not even officially maintained anymore...)

Well *someone* has to still make sure the kernel compiles correctly on
the enterprise distro's that a huge number of Linux users use...
(including RHEL 6, Debian Stable, SLES 11, Ubuntu LTS 10.04, etc.)

:-)

But yeah, I hope to get off of Ubuntu LTS real soon now, and onto
something a bit more hip, such as Debian testing.

						- Ted
