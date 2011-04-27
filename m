Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616Ab1D0ROa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 13:14:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59216 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759517Ab1D0RO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 13:14:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iYm8TH/SaOeFaJtwjUOYKrQYkEsTpIcyS4uJFgQ84WJuaaAujkr61ZiiWAmBQ96Bxq
         vq81ZdwdXqU0CtCOqwDYTzW4sXm+QHLuLrrTE8tDQdRaq1J2po1IhcSh9bls2amWzQOP
         3QJoMxBrGso/F7pK3cRn+u+Kzk196LUBeS2g8=
MIME-Version: 1.0
In-Reply-To: <1303903592-20820-1-git-send-email-j.weitzel@phytec.de>
References: <20110419161452.4c1fd674.akpm@linux-foundation.org>
	<1303903592-20820-1-git-send-email-j.weitzel@phytec.de>
Date: Wed, 27 Apr 2011 19:14:27 +0200
Message-ID: <BANLkTikb2N4AQ8SJqAr7sb54w=KM3Xe89w@mail.gmail.com>
Subject: Re: [PATCH v2] leds: leds-pca9532 add support pca9530, pca9531 and pca9533
From: Joachim Eastwood <manabian@gmail.com>
To: Jan Weitzel <j.weitzel@phytec.de>
Cc: akpm@linux-foundation.org, riku.voipio@iki.fi, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, joachim.eastwood@jotron.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jan,

On 4/27/11, Jan Weitzel <j.weitzel@phytec.de> wrote:
> pca953x family are only different in number of leds and register layout
> Adding chipinfo to use driver with whole pca953x family
> Rename driver to pca953x, but left files and platformflags named pca9532
>
> Tested with pca9530 and pca9533
>
> Tested-by: Juergen Kilb <j.kilb@phytec.de>
> Signed-off-by: Jan Weitzel <j.weitzel@phytec.de>
> ---
> v2: works on top off "pca9532c add gpio capability" patch

I did a short test run with 39-rc5 plus all the pca9532 patches,
including this one, and it works with PCA9532 on my custom board.
Tested both LED and GPIO functionality.

Acked-and-tested-by: Joachim Eastwood <joachim.eastwood@jotron.com>

regards
Joachim Eastwood
