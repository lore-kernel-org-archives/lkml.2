Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab1CNPuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:50:04 -0400
Received: from kroah.org ([198.145.64.141]:50419 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715Ab1CNPt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:49:58 -0400
Date: Mon, 14 Mar 2011 08:47:13 -0700
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Subject: Re: [PATCH v2 11/12] driver: Google EFI SMI
Message-ID: <20110314154713.GF31340@kroah.com>
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
 <20110312014353.6133.94204.stgit@mike.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110312014353.6133.94204.stgit@mike.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 05:43:53PM -0800, Mike Waychison wrote:
> The "gsmi" driver bridges userland with firmware specific routines for
> accessing hardware.

As with the other driver in this series, what keeps this driver from
being loaded on hardware that does not support this functionality?  If
it is loaded, will it cause bad things to happen?

Also, what causes it to be loaded on hardware that needs it?  There
should be some MODULE_DEVICE_TABLE somewhere in this thing to cause it
to be autoloaded?

thanks,

greg k-h
