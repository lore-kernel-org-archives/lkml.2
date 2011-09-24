Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab1IXGCs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 02:02:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62252 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab1IXGCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 02:02:46 -0400
Date: Fri, 23 Sep 2011 23:02:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: John Sung <penmount.touch@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Input: penmount - add PenMount 6000 support
Message-ID: <20110924060240.GA30737@core.coreip.homeip.net>
References: <1315290961-23570-1-git-send-email-penmount.touch@gmail.com>
 <20110907232947.GB32566@core.coreip.homeip.net>
 <20110919153225.GA15609@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110919153225.GA15609@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 04:32:25PM +0100, Matthew Garrett wrote:
> On Wed, Sep 07, 2011 at 04:29:47PM -0700, Dmitry Torokhov wrote:
> > 
> > Initializing a device connected to a serport serio port is actually task
> > of inputattach utility.
> 
> For devices that present a unique pnp ID, we probably ought to support 
> doing this in-kernel rather than relying on inputattach. It makes it 
> easier to handle things like suspend/resume.

I'd prefer to keep all this logic in one place - inputattach. On resume
inputattack returns so we only need to restart it to get input device
back. Thankfully the rest of our infrastructure is ready to handle
hot-plugged devices by now.

Thanks.

-- 
Dmitry
