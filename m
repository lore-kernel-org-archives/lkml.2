Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab2EIVPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 17:15:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47330 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab2EIVPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 17:15:15 -0400
Date: Wed, 9 May 2012 14:15:11 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Manohar Vanga <manohar.vanga@cern.ch>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v4 2/3] Staging: ipack: added support for the TEWS
 TPCI-200 carrier board
Message-ID: <20120509211511.GA23372@kroah.com>
References: <1336570041-32724-1-git-send-email-siglesias@igalia.com>
 <1336570041-32724-2-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336570041-32724-2-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 03:27:20PM +0200, Samuel Iglesias Gonsalvez wrote:
> Driver for the carrier board TEWS TPCI-200, a bridge between PCIe bus and
> IndustryPack bus.
> 
> Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>

Please fix up all of the sparse warnings in this file, there are a bunch
:(

And again, be sure of the "any later version" on your licensing.

thanks,

greg k-h
