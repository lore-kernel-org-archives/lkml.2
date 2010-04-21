Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab0DUSP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 14:15:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab0DUSPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 14:15:50 -0400
Date: Wed, 21 Apr 2010 11:05:12 -0700
From: Greg KH <gregkh@suse.de>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: fabien.chouteau@gmail.com, linux-usb@vger.kernel.org,
       Fabien Chouteau <fabien.chouteau@barco.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Mass storage gadget: Handle eject request
Message-ID: <20100421180512.GA24842@suse.de>
References: <1271864304-4279-1-git-send-email-fabien.chouteau@gmail.com>
 <1271864304-4279-2-git-send-email-fabien.chouteau@gmail.com>
 <op.vbit26d87p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vbit26d87p4s8u@pikus>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 06:43:44PM +0200, Michał Nazarewicz wrote:
> On Wed, 21 Apr 2010 17:38:22 +0200, <fabien.chouteau@gmail.com> wrote:
> >From: Fabien Chouteau <fabien.chouteau@barco.com>
> >
> >
> >Signed-off-by: Fabien Chouteau <fabien.chouteau@barco.com>
> 
> Commit message missing, in both patches.  It should contain some
> details on what the patch does and how this can be used.

I agree, that is a requirement.  Please resubmit these with some
description of what is happening.

thanks,

greg k-h
