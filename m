Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab0IKAJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 20:09:42 -0400
Received: from kroah.org ([198.145.64.141]:55268 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337Ab0IKAJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 20:09:41 -0400
Date: Fri, 10 Sep 2010 17:10:05 -0700
From: Greg KH <greg@kroah.com>
To: David Cross <david.cross@cypress.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] west bridge, Kconfig fix
Message-ID: <20100911001005.GA20027@kroah.com>
References: <1284162665.16135.3.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284162665.16135.3.camel@odc-laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 04:51:05PM -0700, David Cross wrote:
> This patch fixes the currently broken Kconfig for west bridge by
> introducing a dependency on a valid HAL Layer for the driver build.
> 
> Signed-off-by: David Cross <david.cross@cypress.com>

Which order do these 4 patches need to be applied in?  Please read
section 15 in Documentation/SubmittingPatches for details as to how to
properly format things.

thanks,

greg k-h
