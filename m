Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab2HGBoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 21:44:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65191 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab2HGBn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 21:43:59 -0400
Date: Mon, 6 Aug 2012 18:43:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Yann Cantin <yann.cantin@laposte.net>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH v3 2/2] input: misc: New USB eBeam input driver.
Message-ID: <20120807014354.GA21477@core.coreip.homeip.net>
References: <1344288104-20731-1-git-send-email-yann.cantin@laposte.net>
 <1344288104-20731-3-git-send-email-yann.cantin@laposte.net>
 <20120806214359.GB30355@kroah.com>
 <502067C8.2020204@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <502067C8.2020204@laposte.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 02:56:40AM +0200, Yann Cantin wrote:
> Hi,
> 
> Le 06/08/2012 23:43, Greg KH a écrit :
> > On Mon, Aug 06, 2012 at 11:21:44PM +0200, Yann Cantin wrote:
> >>
> >> Signed-off-by: Yann Cantin <yann.cantin@laposte.net>
> >> ---
> >>  drivers/input/misc/ebeam.c |  764 ++++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 764 insertions(+)
> >>  create mode 100644 drivers/input/misc/ebeam.c
> > 
> > What adds this file to the build?
>  
> Sorry, i don't get it : what do you mean ?

Greg meant that you forgot to include Makefile and Kconfig changes with
this patch.

-- 
Dmitry
