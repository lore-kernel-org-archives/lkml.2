Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773Ab0KKHIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 02:08:52 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64076 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab0KKHIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 02:08:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VyNjgJfPUj1J1K236bbYkbR6JzQxTDGmAW/Iu2JJL0GmqumjPPohRqVR1NTeVffdWZ
         uphjpInoqfTUM1uK3kxn3V6N133jQRX1/ze823lqeoukKxkqj1muhE3E7wcnJyRSVo3F
         pAgq51gxui9moZXCjTD799UjcAFt/DQP/4+m4=
Date: Wed, 10 Nov 2010 23:08:43 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Stephane VOLTZ <svoltz@numericable.fr>,
        Edouard TISSERANT <edouard.tisserant@wanadoo.fr>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: acecad - fix a memory leak in usb_acecad_probe
 error path
Message-ID: <20101111070842.GA24413@core.coreip.homeip.net>
References: <1289445715.3183.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289445715.3183.1.camel@mola>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 11:21:55AM +0800, Axel Lin wrote:
> Add a missing usb_free_urb() in usb_acecad_probe() error path.
> 

Applied, thanks Axel.

-- 
Dmitry
