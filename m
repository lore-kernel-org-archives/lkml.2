Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab2B0GLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 01:11:24 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:35982 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab2B0GLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 01:11:23 -0500
Date: Mon, 27 Feb 2012 01:11:01 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: santoshprasadnayak@gmail.com
Cc: adilger@dilger.ca, andrew_perepechko@xyratex.com,
        nikitas_angelinas@xyratex.com, johann@whamcloud.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ext4: MMP: Fix endianness bug.
Message-ID: <20120227061101.GA14204@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, santoshprasadnayak@gmail.com,
	adilger@dilger.ca, andrew_perepechko@xyratex.com,
	nikitas_angelinas@xyratex.com, johann@whamcloud.com,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <4f468ef2.4105440a.56cc.ffffa1d7@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f468ef2.4105440a.56cc.ffffa1d7@mx.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 12:39:05AM +0530, santoshprasadnayak@gmail.com wrote:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> Sparse complaint this endian bug in ext4: mmp.
> 
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>

Thanks, applied.

					- Ted
