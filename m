Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2GTSBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:01:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51294 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab2GTSBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:01:17 -0400
Date: Fri, 20 Jul 2012 11:01:13 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/90] staging: comedi: adv_pci1723: move
 comedi_pci_enable() into the attach
Message-ID: <20120720180113.GB8530@kroah.com>
References: <201207181830.48668.hartleys@visionengravers.com>
 <5007D568.2050401@mev.co.uk>
 <ADE657CA350FB648AAC2C43247A983F00206AA916472@AUSP01VMBX24.collaborationhost.net>
 <20120719231723.GA23010@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F00206AA9165BC@AUSP01VMBX24.collaborationhost.net>
 <20120719233506.GA12858@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F00206AABE0E10@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00206AABE0E10@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 11:33:27AM -0500, H Hartley Sweeten wrote:
> I think there are a couple pci drivers that would still need the old "attach"
> in order to load firmware using comedi_config. We can address those
> later and possibly figure out a more "standard" way to load the firmware.

That "standard" way is to use the kernel's firmware layer for this :)

thanks,

greg k-h
