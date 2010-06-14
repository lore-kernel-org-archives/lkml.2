Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab0FNLRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 07:17:39 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60097 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab0FNLRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 07:17:38 -0400
Date: Mon, 14 Jun 2010 12:17:34 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] UBUNTU: SAUCE: khubd -- switch USB
 product/manufacturer/serial handling to RCU
Message-ID: <20100614111734.GT12061@shadowen.org>
References: <1276514068-23668-1-git-send-email-apw@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276514068-23668-1-git-send-email-apw@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 12:14:28PM +0100, Andy Whitcroft wrote:
> With the introduction of wireless USB hubs the product, manufacturer,
> and serial number are now mutable.  This necessitates new locking in the
> consumers of these values including the sysfs read routines in order to
> prevent use-after-free acces to these values.  These extra locks create
> significant lock contention leading to increased boot times (0.3s for an
> example Atom based system).  Move update of these values to RCU based
> locking.

Bah, some Ubuntu-ism leaked out in the summary test, I've resent it with
those removed.

-apw
