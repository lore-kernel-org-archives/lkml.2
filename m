Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395Ab0GVRrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 13:47:53 -0400
Received: from kroah.org ([198.145.64.141]:54346 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759242Ab0GVRro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 13:47:44 -0400
Date: Thu, 22 Jul 2010 10:46:37 -0700
From: Greg KH <greg@kroah.com>
To: Rene Sapiens <rene.sapiens@ti.com>
Cc: gregkh@suse.de, omar.ramirez@ti.com, ohad@wizery.com,
        ameya.palande@nokia.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 00/15] ti dspbridge: Remove CamelCase, reagroup
 variables
Message-ID: <20100722174637.GA17484@kroah.com>
References: <1278728649-21012-1-git-send-email-rene.sapiens@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278728649-21012-1-git-send-email-rene.sapiens@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 09:23:54PM -0500, Rene Sapiens wrote:
> The intention of this serie of patches is to rename the remaining variables 
> with camel case. Words will be renamed avoiding CamelCase and Hungarian 
> notation. Also the variables in the prototypes  will be renamed to make them 
> match with the ones in the function definitions.
> 
> The variables to be renamed are:

<snip>

All applied, thanks.

greg k-h
