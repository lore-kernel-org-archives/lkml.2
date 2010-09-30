Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab0I3Rak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 13:30:40 -0400
Received: from kroah.org ([198.145.64.141]:50634 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab0I3Raj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 13:30:39 -0400
Date: Thu, 30 Sep 2010 05:12:10 -0700
From: Greg KH <greg@kroah.com>
To: Hank Janssen <hjanssen@sailtheuniverse.com>
Cc: hjanssen@microsoft.com, Haiyang Zhang <haiyangz@microsoft.com>,
        devel@driverdev.osuosl.org, virtualization@lists.osdl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: hv: Remove camel case variables in
	channel.c
Message-ID: <20100930121210.GA14358@kroah.com>
References: <4CA4105E.80602@sailtheuniverse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA4105E.80602@sailtheuniverse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 09:21:50PM -0700, Hank Janssen wrote:
> 
> Rename camel case variables in channel.c and changed them to
> lowercase.
> 
> Sending this from my own accounts till we have a proper mail server
> set up that allows us to send out patches without issues.

This paragraph goes below the '---' line, it doesn't belong in the
change log, right?

> This patch was created by Haiyang Zhang.

Then put the proper "From:" line in the email body like the file,
Documentation/SubmittingPatches tells you to do so that git properly
credits the correct author.

Oh, you also forgot to cc: me so I know to pick the patch up :)

Care to try it again?

thanks,

greg k-h
