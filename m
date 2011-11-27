Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab1K0JcK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 04:32:10 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47355 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878Ab1K0JcH (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 04:32:07 -0500
X-Sasl-enc: XK23xCAUYNH0lj5wOw0et+G/CYItX524cOP/AD76WrrA 1322386324
Date: Sat, 26 Nov 2011 17:08:36 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Piehl <matthew.piehl232@gmail.com>
Cc: gregkh@suse.de, shemminger@vyatta.com, lucas.demarchi@profusion.mobi,
        asedeno@mit.edu, devel@driverdev.osuosl.org,
        Linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: bcm: Fixed major coding style issues
Message-ID: <20111127010836.GA1113@kroah.com>
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
> 
> Signed-off-by: Matthew Piehl <Matthew.Piehl232@gmail.com>
> ---
>  drivers/staging/bcm/Adapter.h |  715 ++++++++++++++++++++---------------------
>  1 files changed, 345 insertions(+), 370 deletions(-)

Please only do one type of cleanup at a time, which makes it easier for
us to review the patch and verify that it all is correct.

Please redo this as a series of patches, each one fixing up one type of
error or warning.

thanks,

greg k-h
