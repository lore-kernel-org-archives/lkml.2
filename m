Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab0LBFev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 00:34:51 -0500
Received: from mail.perches.com ([173.55.12.10]:2123 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab0LBFeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 00:34:50 -0500
Subject: Re: [ath9k-devel] [PATCH 2/2] ath: Fix logging message typos
From: Joe Perches <joe@perches.com>
To: Peter Stuge <peter@stuge.se>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Bob Copeland <me@bobcopeland.com>,
        Jouni Malinen <jmalinen@atheros.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        netdev@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, ath9k-devel@venema.h4ckr.net
In-Reply-To: <20101202053055.19479.qmail@stuge.se>
References: <276469c602c402565b49f99521ea19757429e81e.1291266731.git.joe@perches.com>
	 <a345e995a816576a4c2c39aec43716c18011475b.1291266731.git.joe@perches.com>
	 <20101202053055.19479.qmail@stuge.se>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 21:34:47 -0800
Message-ID: <1291268087.1761.3.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 06:30 +0100, Peter Stuge wrote:
> Joe Perches wrote:
> > +++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
> ..
> > @@ -734,7 +734,7 @@ static bool ar9285_hw_cl_cal(struct ath_hw *ah, struct ath9k_channel *chan)
> >  	if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
> >  			  0, AH_WAIT_TIMEOUT)) {
> >  		ath_dbg(common, ATH_DBG_CALIBRATE,
> > -			"offset calibration failed to complete in 1ms; noisy ??\n");
> > +			"offset calibration failed to complete in 1ms; noisy enfironment?\n");
> 
> enfironment? :)

Umm, what's a typo fix patch without more typos?
Correct?  How dull...

> >  	ath_dbg(common, ATH_DBG_ANI,
> > -		"Getting spur idx %d is2Ghz. %d val %x\n",
> > +		"Getting spur idx:%d is2Ghz:%d val:%x\n",
> >  		i, is2GHz, ah->config.spurchans[i][is2GHz]);
> 
> Is this short for "spurious" ?

Likely.  Anyone want to change it to a whole word?

