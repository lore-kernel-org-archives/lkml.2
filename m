Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527Ab2I1RMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 13:12:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64019 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757681Ab2I1RMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 13:12:22 -0400
Date: Fri, 28 Sep 2012 10:09:40 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 33/57] power: u8500_charger: Delay for USB enumeration
Message-ID: <20120928170939.GA18175@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-34-git-send-email-mathieu.poirier@linaro.org>
 <20120927074238.GN8836@lizard>
 <5065D6D2.9040007@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5065D6D2.9040007@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 10:56:50AM -0600, Mathieu Poirier wrote:
[...]
> >> +	struct delayed_work usb_state_changed_work;
> >>  	struct delayed_work attach_work;
> >>  	struct delayed_work ac_charger_attached_work;
> >>  	struct delayed_work usb_charger_attached_work;
> >> +	struct delayed_work vbus_drop_end_work;
> >>  	struct work_struct ac_work;
> >>  	struct work_struct detect_usb_type_work;
> >>  	struct work_struct usb_link_status_work;
> >> -	struct work_struct usb_state_changed_work;
> > 
> > This just moves line around. Doesn't belong to this patch.
> 
> This is moving 'usb_state_changed_work' from type 'struct work_struct'
> to 'struct delayed_work'.  Is it that you want to see the change on the
> same line rather than two different lines ?

Oh, I see. No, then it's fine as is.

Thanks!
