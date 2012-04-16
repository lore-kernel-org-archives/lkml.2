Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab2DPPvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:51:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47869 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab2DPPv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:51:29 -0400
Message-ID: <4F8C3FFD.6030602@lwfinger.net>
Date: Mon, 16 Apr 2012 10:51:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: LKML <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        wireless <linux-wireless@vger.kernel.org>,
        Jan Simonson <jan@simonson.se>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Problem with crypto when initializing TKIP
References: <4F8BAE2F.5090200@lwfinger.net> <20120416124839.GA5985@gondor.apana.org.au>
In-Reply-To: <20120416124839.GA5985@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 07:48 AM, Herbert Xu wrote:
> On Mon, Apr 16, 2012 at 12:29:19AM -0500, Larry Finger wrote:
>>
>> The value of ok is NOTIFY_OK, which leads to a return of -ENOENT and
>> a failure of the initialization.
>
> NOTIFY_OK means that we have no notifiers installed.  Did you
> compile/load CRYPTO_MANAGER?

Thanks for responding. The CRYPTO_MANAGER is built in, but your suggestion got 
me into the correct area. For some unknown reason, CONFIG_MICHAEL_MIC was 
dropped from my configuration. When I added it, everything works.

I will improve the error message in the driver.

Thanks again,

Larry
