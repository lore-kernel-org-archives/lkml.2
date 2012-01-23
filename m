Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2AWJSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 04:18:46 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56715 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750913Ab2AWJSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 04:18:44 -0500
Date: Mon, 23 Jan 2012 11:18:33 +0200
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH] Regression: Revert "Bluetooth: use buffer priority to
 mark URB_ISO_ASAP flag"
Message-ID: <20120123091833.GA9471@x220>
Mail-Followup-To: Marcel Holtmann <marcel@holtmann.org>,
	Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-bluetooth@vger.kernel.org
References: <1327298281-2502-1-git-send-email-keithp@keithp.com>
 <1327309415.1955.87.camel@aeonflux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327309415.1955.87.camel@aeonflux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,

On Mon, Jan 23, 2012, Marcel Holtmann wrote:
> > URB_ISO_ASAP may only be used with iso end points, but this patch was
> > attempting to use it with a bulk endpoint. When DEBUG is defined in
> > the USB stack, it checks for invalid flags and returns -EINVAL instead
> > of actually transmitting the data.
> > 
> > Signed-off-by: Keith Packard <keithp@keithp.com>
> > ---
> 
> a version of this patch should be already upstream or in stable trees.
> If you are sending this again, then it might slipped through. Johan?

It's here:

http://git.kernel.org/?p=linux/kernel/git/jh/bluetooth-next.git;a=commitdiff;h=e2bcdc65928af5f2b509a8c4d8b4469901f6522f

Johan
