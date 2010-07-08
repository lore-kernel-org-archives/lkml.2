Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771Ab0GHXct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:32:49 -0400
Received: from kroah.org ([198.145.64.141]:48953 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470Ab0GHXcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:32:48 -0400
Date: Thu, 8 Jul 2010 16:32:13 -0700
From: Greg KH <greg@kroah.com>
To: Rene Sapiens <rene.sapiens@ti.com>
Cc: gregkh@suse.de, omar.ramirez@ti.com, ohad@wizery.com,
       ameya.palande@nokia.com, fernando.lugo@ti.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] staging: ti dspbridge: Remove CamelCase,
 reagroup variables.
Message-ID: <20100708233213.GA22813@kroah.com>
References: <1278630683-1062-1-git-send-email-rene.sapiens@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278630683-1062-1-git-send-email-rene.sapiens@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 06:11:07PM -0500, Rene Sapiens wrote:
> The intention of this serie of patches is to rename the remaining variables 
> with camel case. Words will be renamed avoiding CamelCase and Hungarian 
> notation. Also the variables in the prototypes  will be renamed to make them 
> match with the ones in the function definitions.
> 
> The variables to be renamed are:

<snip>

Only the 1st patch in this series applied, probably due to the other
changes that I just accepted into the linux-next tree for this driver.

So, can you rebase the remaining 15 patches against the linux-next tree
of tomorrow and resend them?

thanks,

greg k-h
