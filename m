Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab0IPODt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 10:03:49 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45004 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab0IPODs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 10:03:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tir2qnKvQGlxtURVeeJpbV8L8cbOa/YQMuot/lcf01l8gcRgKJ3vah260tS+Pnz6yI
         1Wj1laNcbyS/5T8diY9r5tqZbSedcGqWRSvvpNrTgy5YRqOZ/2MNGkspexQXhk86wIgU
         HahJUDf6CErmLal9p1rW+VtsNfp51BxHy6VUg=
Subject: Re: [PATCH] block: fix an warning of calling blk_rq_aligned()
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4C91B7C4.6030802@kernel.dk>
References: <20100916133005.56baad7e.sfr@canb.auug.org.au>
	 <1284609357-3076-1-git-send-email-namhyung@gmail.com>
	 <4C91B7C4.6030802@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 23:03:36 +0900
Message-ID: <1284645816.1682.1.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-09-16 (목), 08:23 +0200, Jens Axboe:
> Thanks, in the future please ensure that you have all{yes,mod}config
> tested patches you submit.
> 

OK. Sorry for the inconvenience.

-- 
Regards,
Namhyung Kim


