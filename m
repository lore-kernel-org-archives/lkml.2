Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab2GFVXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:23:42 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37382 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab2GFVXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:23:41 -0400
Date: Fri, 6 Jul 2012 17:23:33 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: mfd: wm831x: Feed the device UUID into device_add_randomness()
Message-ID: <20120706212333.GA4877@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
	patches@opensource.wolfsonmicro.com
References: <1341519801-5904-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341519801-5904-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 08:23:21PM -0000, Mark Brown wrote:
> wm831x devices contain a unique ID value. Feed this into the newly added
> device_add_randomness() to add some per device seed data to the pool.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> add_device_randomness() has only just been added in -next, this will
> need to either wait until after the merge window or be merged along with
> the patch adding it.

Thanks, I've added this to the /dev/random git tree.

	     	   	       		   - Ted
