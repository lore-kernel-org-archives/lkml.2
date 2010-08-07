Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761445Ab0HGIxv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 04:53:51 -0400
Received: from mx6.orcon.net.nz ([219.88.242.56]:51505 "EHLO mx6.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab0HGIxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 04:53:47 -0400
Message-ID: <4C5D1F18.9040105@orcon.net.nz>
Date: Sat, 07 Aug 2010 20:53:44 +1200
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: Morten Holst Larsen <m-larsen@post6.tele.dk>
CC: linux-alpha@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH] Fix call to replaced SuperIO functions
References: <E1OfBMn-00058R-O4@mhlnet.dk>
In-Reply-To: <E1OfBMn-00058R-O4@mhlnet.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx6.orcon.net.nz on Sat, 07 Aug 2010 20:53:44 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sat Aug  7 20:53:45 2010
X-DSPAM-Confidence: 0.5537
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/10 00:40, Morten Holst Larsen wrote:
> Fix call to replaced SuperIO functions
>
> This patch fixes the failure to compile Alpha Generic because of
> previously overlooked calls to ns87312_enable_ide(). The function has
> been replaced by newer SuperIO code.
>
> Signed-off-by: Morten H. Larsen<m-larsen@post6.tele.dk>

Tested-by: Michael Cree <mcree@orcon.net.nz>

Applied to 2.6.35 and verified that the Alpha generic build compiles and 
is running on an Alpha.  (Well, there 's also a printf format compile 
error elsewhere in the build but that's a separate issue and I will soon 
get around to posting a patch for that.)

When accepted into mainline this should also go to the stable series.

Cheers
Michael.
