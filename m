Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353Ab0GVRrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 13:47:48 -0400
Received: from kroah.org ([198.145.64.141]:54341 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759195Ab0GVRrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 13:47:43 -0400
Date: Thu, 22 Jul 2010 10:43:49 -0700
From: Greg KH <greg@kroah.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: "Sapiens, Rene" <rene.sapiens@ti.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 00/15] ti dspbridge: Remove CamelCase, reagroup
 variables
Message-ID: <20100722174349.GA1166@kroah.com>
References: <1278728649-21012-1-git-send-email-rene.sapiens@ti.com>
 <4C40F688.80507@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C40F688.80507@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 07:17:12PM -0500, Omar Ramirez Luna wrote:
> On 7/9/2010 9:23 PM, Sapiens, Rene wrote:
> >The intention of this serie of patches is to rename the remaining variables
> >with camel case. Words will be renamed avoiding CamelCase and Hungarian
> >notation. Also the variables in the prototypes  will be renamed to make them
> >match with the ones in the function definitions.
> >
> [...]
> >  74 files changed, 2471 insertions(+), 2439 deletions(-)
> >
> >
> 
> Some of your patches produce:
> 
> warning: drivers/staging/tidspbridge/include/dspbridge/dspdefs.h has
> type 100644, expected 100755
> 
> None of the files had their permissions changed so I guess they
> should be fine to merge, unless anybody else complains... so ACK.

Yeah, Rene, what are you doing changing the mode of these files?  Git
shows those types of mode changes.

Ick, I'll edit them all out...

thanks,

greg k-h
