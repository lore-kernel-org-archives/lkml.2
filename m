Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056Ab1J1Qkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 12:40:49 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:55634 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933039Ab1J1Qkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 12:40:46 -0400
X-Sasl-enc: tK3GHJ0nglERVDZGN68ZYUyfbvmUbrZY8+vZxht3ClTK 1319820045
Date: Fri, 28 Oct 2011 18:37:06 +0200
From: Greg KH <greg@kroah.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: hjk@hansjkoch.de, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] Example to show use of uio pgprot
Message-ID: <20111028163706.GB27444@kroah.com>
References: <1319817030-23992-1-git-send-email-galak@kernel.crashing.org>
 <1319817030-23992-2-git-send-email-galak@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319817030-23992-2-git-send-email-galak@kernel.crashing.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 10:50:30AM -0500, Kumar Gala wrote:
> ---
>  drivers/uio/uio_dpa.c |  200 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 200 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/uio/uio_dpa.c

You do realize this does not build, right?

thanks,

greg k-h
