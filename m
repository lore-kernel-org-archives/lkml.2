Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab0GMLH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 07:07:59 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:59542 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830Ab0GMLH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 07:07:58 -0400
Message-ID: <4C3C4903.7010201@st.com>
Date: Tue, 13 Jul 2010 16:37:47 +0530
From: Viresh KUMAR <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Lightning/1.0b1 Thunderbird/3.0.5
MIME-Version: 1.0
To: dave.bueso@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        trivial@vger.kernel.org
Subject: Re: [PATCH RESEND padmux.c] Fix typo in kerneldoc
References: <1279014561.18280.0.camel@cowboy>
In-Reply-To: <1279014561.18280.0.camel@cowboy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/13/2010 3:19 PM, Davidlohr Bueso wrote:
> Trivial fix in a typo (enalbed for enabled).
> 
> Thanks,
> Davidlohr
> 
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  arch/arm/plat-spear/padmux.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/plat-spear/padmux.c b/arch/arm/plat-spear/padmux.c
> index d2aab3a..555eec6 100644
> --- a/arch/arm/plat-spear/padmux.c
> +++ b/arch/arm/plat-spear/padmux.c
> @@ -66,7 +66,7 @@ static int pmx_mode_set(struct pmx_mode *mode)
>   * If peripheral is not supported by current mode then request is rejected.
>   * Conflicts between peripherals are not handled and peripherals will be
>   * enabled in the order they are present in pmx_dev array.
> - * In case of conflicts last peripheral enalbed will be present.
> + * In case of conflicts last peripheral enabled will be present.
>   * Returns -ve on Err otherwise 0
>   */
>  static int pmx_devs_enable(struct pmx_dev **devs, u8 count)

Acked-by: Viresh Kumar <viresh.kumar@st.com>
