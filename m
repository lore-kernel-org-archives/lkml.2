Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab0LBFa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 00:30:57 -0500
Received: from foo.stuge.se ([213.88.146.6]:40276 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751680Ab0LBFa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 00:30:56 -0500
Message-ID: <20101202053055.19479.qmail@stuge.se>
Date: Thu, 2 Dec 2010 06:30:54 +0100
From: Peter Stuge <peter@stuge.se>
To: Joe Perches <joe@perches.com>
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
Subject: Re: [ath9k-devel] [PATCH 2/2] ath: Fix logging message typos
Mail-Followup-To: Joe Perches <joe@perches.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	netdev@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org, ath9k-devel@lists.ath9k.org
References: <276469c602c402565b49f99521ea19757429e81e.1291266731.git.joe@perches.com> <a345e995a816576a4c2c39aec43716c18011475b.1291266731.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a345e995a816576a4c2c39aec43716c18011475b.1291266731.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> +++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
..
> @@ -734,7 +734,7 @@ static bool ar9285_hw_cl_cal(struct ath_hw *ah, struct ath9k_channel *chan)
>  	if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
>  			  0, AH_WAIT_TIMEOUT)) {
>  		ath_dbg(common, ATH_DBG_CALIBRATE,
> -			"offset calibration failed to complete in 1ms; noisy ??\n");
> +			"offset calibration failed to complete in 1ms; noisy enfironment?\n");

enfironment? :)


> +++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
..
> @@ -1178,7 +1178,7 @@ static u16 ath9k_hw_4k_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
>  	u16 spur_val = AR_NO_SPUR;
>  
>  	ath_dbg(common, ATH_DBG_ANI,
> -		"Getting spur idx %d is2Ghz. %d val %x\n",
> +		"Getting spur idx:%d is2Ghz:%d val:%x\n",
>  		i, is2GHz, ah->config.spurchans[i][is2GHz]);

Is this short for "spurious" ?


//Peter
