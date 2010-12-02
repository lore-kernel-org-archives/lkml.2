Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab0LBGBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 01:01:31 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43238 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab0LBGB3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 01:01:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mbB3GaBkevYwyu7S3Nplte3YHN1gQsR1+2uxlIxPyuTJ6Uu6I290RM0+eP7JXsiq5p
         qk2wEvefrW2lmwqs797M3HXcmUoDfuITDbdGCs+sPfoTfRHgQQoPY4jHu250UHZMUnOk
         FQP4CafZSXt6hMWCEL2DqD3oE1SRKjtEfnOj8=
MIME-Version: 1.0
In-Reply-To: <1291268087.1761.3.camel@Joe-Laptop>
References: <276469c602c402565b49f99521ea19757429e81e.1291266731.git.joe@perches.com>
	<a345e995a816576a4c2c39aec43716c18011475b.1291266731.git.joe@perches.com>
	<20101202053055.19479.qmail@stuge.se>
	<1291268087.1761.3.camel@Joe-Laptop>
Date: Thu, 2 Dec 2010 08:01:26 +0200
Message-ID: <AANLkTimimyhHT2=xT1T8vJ=3WZB4h85ur=yvEfT2Wv-p@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH 2/2] ath: Fix logging message typos
From: Nick Kossifidis <mickflemm@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Peter Stuge <peter@stuge.se>, Jiri Slaby <jirislaby@gmail.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Bob Copeland <me@bobcopeland.com>,
        Jouni Malinen <jmalinen@atheros.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        netdev@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/2 Joe Perches <joe@perches.com>:
> On Thu, 2010-12-02 at 06:30 +0100, Peter Stuge wrote:
>> Joe Perches wrote:
>> > +++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
>> ..
>> > @@ -734,7 +734,7 @@ static bool ar9285_hw_cl_cal(struct ath_hw *ah, struct ath9k_channel *chan)
>> >     if (!ath9k_hw_wait(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_CAL,
>> >                       0, AH_WAIT_TIMEOUT)) {
>> >             ath_dbg(common, ATH_DBG_CALIBRATE,
>> > -                   "offset calibration failed to complete in 1ms; noisy ??\n");
>> > +                   "offset calibration failed to complete in 1ms; noisy enfironment?\n");
>>
>> enfironment? :)
>
> Umm, what's a typo fix patch without more typos?
> Correct?  How dull...
>
>> >     ath_dbg(common, ATH_DBG_ANI,
>> > -           "Getting spur idx %d is2Ghz. %d val %x\n",
>> > +           "Getting spur idx:%d is2Ghz:%d val:%x\n",
>> >             i, is2GHz, ah->config.spurchans[i][is2GHz]);
>>
>> Is this short for "spurious" ?
>
> Likely.  Anyone want to change it to a whole word?
>
>

Nope it stands for spur noise (harmonics)
http://www.patentgenius.com/patent/7835456.html

(I have to add that link to the comments, it's new ;-))

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
