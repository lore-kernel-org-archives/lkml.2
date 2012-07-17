Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab2GQBB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 21:01:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63462 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2GQBBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 21:01:55 -0400
Date: Mon, 16 Jul 2012 18:01:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: move uevent call to driver_register
Message-ID: <20120717010151.GA16615@kroah.com>
References: <alpine.LFD.2.02.1207021900100.1784@c4eb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1207021900100.1784@c4eb>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 07:08:15PM +0200, Sebastian Ott wrote:
> 
> Device driver attribute groups are created after userspace is notified
> via an add event. Fix this by moving the kobject_uevent call to
> driver_register after the attribute groups are added.
> 
> Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>

Nice find, thanks for this.

greg k-h
