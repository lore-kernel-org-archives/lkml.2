Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab0LOIxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 03:53:25 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55180 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab0LOIxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 03:53:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=H8egErREVO338ZWQoyMEOlxECpHNAkG3syM4vmD/S1WgSU3/xNRmivUPSviDP7VpeW
         Bll6mO+XF08jYiwqmPcHEWi5u0ljC3YENvTyDdvAEo+4lSLGBCDL1NJxgMT+HPKBp31k
         zExUgg4cOUYySe750F65x8ZF6UZjg8hUxEdjI=
Date: Wed, 15 Dec 2010 11:53:05 +0300
From: Dan Carpenter <error27@gmail.com>
To: Rene Sapiens <rene.sapiens@ti.com>
Cc: omar.ramirez@ti.com, nm@ti.com, ohad@wizery.com, ionut.nicu@mindbit.ro,
        devel@driverdev.osuosl.org, ivan.gomez@ti.com, x0095078@ti.com,
        felipe.contreras@gmail.com, ernesto@ti.com,
        linux-kernel@vger.kernel.org, x0095840@ti.com,
        linux-omap@vger.kernel.org, ameya.palande@nokia.com
Subject: Re: [PATCH 05/12] staging:tidspbridge - set5 remove hungarian from
 structs
Message-ID: <20101215085305.GC1639@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Rene Sapiens <rene.sapiens@ti.com>, omar.ramirez@ti.com, nm@ti.com,
	ohad@wizery.com, ionut.nicu@mindbit.ro, devel@driverdev.osuosl.org,
	ivan.gomez@ti.com, x0095078@ti.com, felipe.contreras@gmail.com,
	ernesto@ti.com, linux-kernel@vger.kernel.org, x0095840@ti.com,
	linux-omap@vger.kernel.org, ameya.palande@nokia.com
References: <1292358798-25875-1-git-send-email-rene.sapiens@ti.com>
 <1292358798-25875-2-git-send-email-rene.sapiens@ti.com>
 <1292358798-25875-3-git-send-email-rene.sapiens@ti.com>
 <1292358798-25875-4-git-send-email-rene.sapiens@ti.com>
 <1292358798-25875-5-git-send-email-rene.sapiens@ti.com>
 <1292358798-25875-6-git-send-email-rene.sapiens@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292358798-25875-6-git-send-email-rene.sapiens@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 02:33:11PM -0600, Rene Sapiens wrote:
> -				    pfn_unload(pnode->nldr_node_obj,
> +				    load(pnode->nldr_node_obj,
>  					       NLDR_EXECUTE);

Unload got swapped with load here.

This might have been easier to with Coccinelle instead of by hand...

regards,
dan carpenter

