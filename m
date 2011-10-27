Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab1J0GAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 02:00:48 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:33525 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753257Ab1J0GAg (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 02:00:36 -0400
X-Sasl-enc: Gzn10mFdLDDneL7kc0HDJPCKUnNSsOCUQu+CeuWRLgn2 1319695235
Date: Thu, 27 Oct 2011 07:52:23 +0200
From: Greg KH <greg@kroah.com>
To: Matthew Piehl <matthew.piehl232@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, asedeno@mit.edu,
        lucas.demarchi@profusion.mobi, Linux-kernel@vger.kernel.org,
        shemminger@vyatta.com
Subject: Re: [PATCH] staging: bcm: Fixed major coding style issues
Message-ID: <20111027055223.GB1388@kroah.com>
References: <1319669560-10979-1-git-send-email-Matthew.Piehl232@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319669560-10979-1-git-send-email-Matthew.Piehl232@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 05:52:40PM -0500, Matthew Piehl wrote:
> Fixed major coding style issues and removed all checkpatch errors and
> and many warnings.

You just did a whole lot of things all in one patch, making it very hard
to review.

Please break it up into one-patch-per-logical-change, and no, "fix
everything" is not a single logical change :)

Also, please check Linus's current tree to see if this even applies, I
don't want you to do work that's already been done as that would be sad.

thanks,

greg k-h
