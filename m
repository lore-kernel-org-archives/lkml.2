Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab1DZApX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 20:45:23 -0400
Received: from kroah.org ([198.145.64.141]:39970 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102Ab1DZApW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 20:45:22 -0400
Date: Mon, 25 Apr 2011 17:32:37 -0700
From: Greg KH <greg@kroah.com>
To: Kenji Toyama <kenji.toyama@gmail.com>
Cc: gregkh@suse.de, aaro.koskinen@iki.fi, wfp5p@virginia.edu,
        martinez.javier@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11] Staging: xgifb: Fixed style issues.
Message-ID: <20110426003237.GA13470@kroah.com>
References: <1303627965-3587-1-git-send-email-kenji.toyama@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303627965-3587-1-git-send-email-kenji.toyama@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 24, 2011 at 02:52:45PM +0800, Kenji Toyama wrote:
> Now there's only 10 errors and 1 warning given by checkpatch.pl, and
> these are related initialization of statics. The only warning left can
> be safely ignored I believe.
> 
> Signed-off-by: Daniel Kenji Toyama <kenji.toyama@gmail.com>

This no longer applies to my tree.  Care to redo it and your 12/12 patch
so I can apply them?

thanks,

greg k-h
