Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915Ab1IIUqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 16:46:18 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54315 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759888Ab1IIUqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 16:46:13 -0400
X-Sasl-enc: VBVhkZUhjinM/X38EoszOIr0GSiWz/fGLukTL7dDLU5I 1315601172
Date: Fri, 9 Sep 2011 13:27:52 -0700
From: Greg KH <greg@kroah.com>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: gregkh@suse.de, martyn.welch@ge.com, cota@braap.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] [RESEND v5] VME Framework Fixes
Message-ID: <20110909202752.GA14247@kroah.com>
References: <1314868526-13230-1-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314868526-13230-1-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 11:15:23AM +0200, Manohar Vanga wrote:
> Hi Greg, Martyn, Emilio,
> 
> This is the resend of the patches with additional code added to patch 3 to
> remove devices in the case that a bridge driver is removed. (I don't know how
> common it is to keep resending patchsets so I apologize for any noise I may
> be causing).

resends are normal and not a problem.

I've applied the first patch in this series, please rework the other two
to get them accepted as well.

thanks,

greg k-h
