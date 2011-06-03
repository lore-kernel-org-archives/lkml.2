Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab1FCJVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 05:21:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37665 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab1FCJVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 05:21:07 -0400
Date: Fri, 3 Jun 2011 10:20:57 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
        Jamie Iles <jamie@jamieiles.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH] mtd: denali: remove calling mtd_device_unregister()
 after nand_release()
Message-ID: <20110603092057.GC2637@pulham.picochip.com>
References: <1307063535.10001.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307063535.10001.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 09:12:15AM +0800, Axel Lin wrote:
> The implementation of nand_release() already call mtd_device_unregister(),
> no need to call it again.

Good catch!

> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Jamie Iles <jamie@jamieiles.com>
