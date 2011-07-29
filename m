Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab1G2NyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 09:54:09 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3691 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab1G2NyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 09:54:07 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4E32BB6F.3090607@broadcom.com>
Date: Fri, 29 Jul 2011 15:53:51 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18)
 Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Michael Witten" <mfwitten@gmail.com>
cc: "Jiri Kosina" <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Docs: Typo: coordinate{,s}
References: <8d47115a01b74b768ea4850fb314b16d-mfwitten@gmail.com>
 <768a3afa74c244e8b43a376dd4fb0df4-mfwitten@gmail.com>
In-Reply-To: <768a3afa74c244e8b43a376dd4fb0df4-mfwitten@gmail.com>
X-WSS-ID: 622C63133KO526056-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2011 02:46 PM, Michael Witten wrote:
> Signed-off-by: Michael Witten<mfwitten@gmail.com>
> ---
>   include/linux/cordic.h |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/cordic.h b/include/linux/cordic.h
> index f932093..de741da 100644
> --- a/include/linux/cordic.h
> +++ b/include/linux/cordic.h
> @@ -35,8 +35,8 @@ struct cordic_iq {
>    * @theta: angle in degrees for which i/q coordinate is to be calculated.
>    * @coord: function output parameter holding the i/q coordinate.
>    *
> - * The function calculates the i/q coordinate for a given angle using
> - * cordic algorithm. The coordinate consists of a real (i) and an
> + * The function calculates the i/q coordinates for a given angle using
> + * cordic algorithm. The coordinates consist of a real (i) and an
>    * imaginary (q) part. The real part is essentially the cosine of the
>    * angle and the imaginary part is the sine of the angle. The returned
>    * values are scaled by 2^16 for precision. The range for theta is

Most patches in this series are fine by me. However, the function takes 
a single angle as input and returns a single two-dimensional coordinate 
as output. The coordinate itself is represented by the two axis i and q. 
So I tend to say changing coordinate to coordinates is not justified 
here. However, I not a native english speaker so I may be wrong here.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


