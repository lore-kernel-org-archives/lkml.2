Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab1BQPwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:52:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:52926 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756Ab1BQPwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:52:04 -0500
Date: Thu, 17 Feb 2011 16:52:02 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Luciano Coelho <coelho@ti.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]drivers:wireless:acx.h change initate to initiate
In-Reply-To: <1296244444.3069.399.camel@pimenta>
Message-ID: <alpine.LNX.2.00.1102171651530.2160@pobox.suse.cz>
References: <1296244204-3890-1-git-send-email-justinmattock@gmail.com> <1296244444.3069.399.camel@pimenta>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011, Luciano Coelho wrote:

> > Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> > 
> > ---
> >  drivers/net/wireless/wl12xx/acx.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
> > index 7bd8e4d..c56088b 100644
> > --- a/drivers/net/wireless/wl12xx/acx.h
> > +++ b/drivers/net/wireless/wl12xx/acx.h
> > @@ -987,7 +987,7 @@ struct wl1271_acx_ht_capabilities {
> >  	 *         Note, driver will still leave space for HT control in packets
> >  	 *         regardless of the value of this field. FW will be responsible
> >  	 *         to drop the HT field from any frame when this Bit set to 0.
> > -	 * bit 5 - Allow RD initiation in TXOP. FW is allowed to initate RD.
> > +	 * bit 5 - Allow RD initiation in TXOP. FW is allowed to initiate RD.
> >  	 *         Exact policy setting for this feature is TBD.
> >  	 *         Note, this bit can only be set to 1 if bit 3 is set to 1.
> >  	 */
> 
> Yep, it's a typo.  Thanks for fixing it.
> 
> Acked-by: Luciano Coelho <coelho@ti.com>

Applied.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
