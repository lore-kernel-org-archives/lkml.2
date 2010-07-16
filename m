Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935783Ab0GPHNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 03:13:01 -0400
Received: from kroah.org ([198.145.64.141]:60442 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935774Ab0GPHM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 03:12:59 -0400
Date: Fri, 16 Jul 2010 00:13:20 -0700
From: Greg KH <greg@kroah.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/7] De-couple sysfs memory directories from memory
	sections
Message-ID: <20100716071320.GC31612@kroah.com>
References: <4C3B3446.5090302@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3B3446.5090302@austin.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 10:27:02AM -0500, Nathan Fontenot wrote:
> This set of patches de-couples the idea that there is a single
> directory in sysfs for each memory section.

Any reason you didn't cc: the sysfs maintainer on these patches?  If
not, I'll gladly ignore them...

(hint, scripts/get_maintainer.pl is your friend...)

greg k-h
