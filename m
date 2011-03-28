Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1C1NBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 09:01:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46511 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1C1NBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:01:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wBfTMxVP84BNROtxfFhI47fC2fxxq58hnuAmt36T/58jG2l1sAfUWLHKZgPAYMeCOY
         UK8nviUF8+gS+sxb9uB3uHiypAxdkO/NHLk9xWkcIJxcvNPzHJrIFhR21tQJKuX3XQiA
         Yf01C2z0O20Z9B6Za0fAPT+17GjR/nfaG5CO8=
Subject: Re: [PATCH] ata: pata_at91.c bugfix for initial_timing
 initialisation
From: Igor Plyatov <plyatov@gmail.com>
Reply-To: plyatov@gmail.com
To: Sergei Shtylyov <sshtylyov@mvista.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D906C40.6040104@ru.mvista.com>
References: <1301313545-22730-1-git-send-email-plyatov@gmail.com>
	 <4D906C40.6040104@ru.mvista.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Mar 2011 17:01:15 +0400
Message-ID: <1301317275.29670.3.camel@homepc>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sergei and Eric,

It's so stupid from my side to send broken patch, but it happens :-)

Please, look at new my e-mails with subjects:
* "[PATCH v4 1/2] ata: pata_at91.c bugfix for initial_timing
initialisation"
* "[PATCH v4 2/2] ata: pata_at91.c bugfix for high master clock"

Best regards!
--
Igor Plyatov

> Hello.
> 
> Igor Plyatov wrote:
> 
> > The "struct ata_timing" must contain 10 members, but ".dmack_hold" member was
> > forgotten for "initial_timing" initialisation. This patch fixes such a problem.
> 
> > Signed-off-by: Igor Plyatov <plyatov@gmail.com>
> > ---
> >  drivers/ata/pata_at91.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> > diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
> > index 0da0dcc..d1aaeb5 100644
> > --- a/drivers/ata/pata_at91.c
> > +++ b/drivers/ata/pata_at91.c
> > @@ -49,8 +49,9 @@ struct at91_ide_info {
> >  	void __iomem *alt_addr;
> >  };
> >  
> > -static const struct ata_timing initial_timing =
> > -	{XFER_PIO_0, 70, 290, 240, 600, 165, 150, 600, 0};
> > +static const struct ata_timing initial_timing = {
> > +	XFER_PIO_0, 70, 290, 240, 600, 165, 150, 600, 0
> > +};
> 
>     Frankly, I don't see any difference.
> 
> WBR, Sergei


