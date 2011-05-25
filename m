Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab1EYCex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 22:34:53 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:57533 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab1EYCew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 22:34:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HbMXJY+VfGfyR+neKwky90HlE+km/bE7o0hAK3MxQuVLB/WpxNHhy32ZLcK/IN6xbw
         4Anh6lqI/daXGLTHrC16ApPFpMzm+Pjs3SlUQmYi2ao2vvI/uUg5Hmjw5pnPpN0g5V30
         2TZio6xQ+TmgiEURFpiI5Pa84NAaOBTmJnfRU=
Subject: Re: [PATCH 2/4] cfq-iosched: reduce bit operations in
 cfq_choose_req()
From: Namhyung Kim <namhyung@gmail.com>
To: Justin TerAvest <teravest@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTi=kur2RMzUNC4V1R-R86qJZrk1n6Q@mail.gmail.com>
References: <1306207131-2296-1-git-send-email-namhyung@gmail.com>
	 <1306207131-2296-2-git-send-email-namhyung@gmail.com>
	 <BANLkTi=kur2RMzUNC4V1R-R86qJZrk1n6Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 11:34:44 +0900
Message-ID: <1306290884.1319.18.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-05-24 (화), 10:34 -0700, Justin TerAvest:
> Why make this change? Are we that sensitive to the number of operations?
> 
> It makes the code a bit harder to read, I think.
> 

Hi Justin,

I thought that the function is a sort of hot path operation so it would
be better make it even a bit faster, no? And if you guys think this
patch makes the code harder we can add a comment, although I don't think
it's hard enough. :)

Thanks.


-- 
Regards,
Namhyung Kim


