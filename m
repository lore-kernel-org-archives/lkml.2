Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518Ab0J1OeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 10:34:08 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50102 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933480Ab0J1OeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 10:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fgZPZ8l7UTcijb61JzIUnxfCa6zsczoughTDIcV4l0BP+xNskke5SRCKJrDj1BxWuQ
         OMdRtmJOLk7dO9RZ6w6boy1wx0zzOlDFqLSk0ujlZ3Fw4udZDMCYeOc9dVojxNY9A/uR
         /bbsUqOC+hKf6QnNe4qrCK4nhL8Ifepz9Gsu8=
MIME-Version: 1.0
In-Reply-To: <1288242011-32257-1-git-send-email-alex@wigen.net>
References: <1288242011-32257-1-git-send-email-alex@wigen.net>
Date: Thu, 28 Oct 2010 10:34:03 -0400
Message-ID: <AANLkTi=t-X96a2m9kmP_j+nT=tKjyOJZBsOspuBT4TmM@mail.gmail.com>
Subject: Re: [PATCH] via-velocity: Codestyle fixes
From: Bob Beers <bob.beers@gmail.com>
To: alex@wigen.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 1:00 AM,  <alex@wigen.net> wrote:
> From: Alexander Wigen <alex@wigen.net>

>  static void mac_wol_reset(struct mac_regs __iomem *regs)
> @@ -342,7 +342,7 @@ VELOCITY_PARAM(ValPktLen, "Receiving or Drop invalid 802.3 frame");
>    1: Wake up if link status is on/off.
>    2: Wake up if recevied an arp packet.
>    4: Wake up if recevied any unicast packet.
> -   Those value can be sumed up to support more than one option.
> +   Those value can be summed up to support more than one option.
>  */
>  VELOCITY_PARAM(wol_opts, "Wake On Lan options");
>

my $.02 ...

s/recevied/receive/ x2

s/These values can be summed/Those value can be summed up/

-Bob Beers
