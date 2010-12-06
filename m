Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab0LFVfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 16:35:44 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54249 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab0LFVfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 16:35:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=W6FfnJAvHXwNdGjqzo0jAQ7GuvdzzXP0FVUQxyU93Gk/2CbSkYte3Z3Z+6TUsuA/nx
         MT0yqzUc7vUTfTl1FY4HbrreJyQLj/pIx9Tu9mngFx0omCqoeEfxRElzvQd8XL7RodtJ
         krMoWEJL2Guj7L26to2OgJLDaMMi/YBH/xr00=
MIME-Version: 1.0
In-Reply-To: <20101206212326.GI883@vigoh>
References: <1290763257-12382-1-git-send-email-pavan_savoy@ti.com>
	<20101130154654.GE5919@vigoh>
	<AANLkTiktDkjFH=aGbu3f+mkVUgmFDwB6xLW3e1VNXKtz@mail.gmail.com>
	<20101206212326.GI883@vigoh>
Date: Mon, 6 Dec 2010 22:35:41 +0100
Message-ID: <AANLkTimJiHhkwb-0PQqc6n3wJwx2WPterQqMCXqzce8z@mail.gmail.com>
Subject: Re: [PATCH v7] Bluetooth: btwilink driver
From: Vitaly Wool <vitalywool@gmail.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: Pavan Savoy <pavan_savoy@ti.com>, marcel@holtmann.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gustavo,

On Mon, Dec 6, 2010 at 10:23 PM, Gustavo F. Padovan
<padovan@profusion.mobi> wrote:

> Can't you differentiate Bluetooth data in a generic way, withou looking if it
> is ACL, SCO or HCI EVENT? That done, you can just accumulate in a buffer all
> the Bluetooth data you received in that stream then send it to Bluetooth
> driver after finish that stream processing.

I'm afraid he can't do this because he needs to route events to the
appropriate entity (BT/FM/GPS). I'm not sure how it can be done
without analyzing the incoming packet.

Thanks,
   Vitaly
