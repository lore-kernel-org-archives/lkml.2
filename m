Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755Ab2JXRpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:45:18 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44718 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756417Ab2JXRpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:45:16 -0400
Date: Wed, 24 Oct 2012 19:45:08 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Felipe Balbi <balbi@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb/gadget: let file storage gadget select libcomposite
Message-ID: <20121024174508.GA6014@breakpoint.cc>
References: <20121018144614.b61961cfae2274d52d340882@canb.auug.org.au>
 <50809624.30601@xenotime.net>
 <20121024144435.GF4368@breakpoint.cc>
 <xa1thapjlqv1.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xa1thapjlqv1.fsf@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 07:30:42PM +0200, Michal Nazarewicz wrote:
> At first it looks strange as FSG does not use composite, but yeah:

Yeah. However, it should be removed in v3.8 anyway :)

> Acked-by: Michal Nazarewicz <mina86@mina86.com>

Sebastian
