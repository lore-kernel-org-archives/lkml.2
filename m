Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab2CLGzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 02:55:40 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:33000 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751269Ab2CLGzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 02:55:31 -0400
Message-ID: <4F5D9DB4.1030404@st.com>
Date: Mon, 12 Mar 2012 12:24:44 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Bhavna YADAV <bhavna.yadav@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>,
        Salvatore DE DOMINICIS <salvatore.dedominicis@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] input/spear-keyboard: Remove kbd_set_plat_data()
References: <8acf668a2c8d67aec3dc79dfe2895b2fd80a18be.1330320826.git.viresh.kumar@st.com>
In-Reply-To: <8acf668a2c8d67aec3dc79dfe2895b2fd80a18be.1330320826.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/2012 11:09 AM, Viresh KUMAR wrote:
> We must use platform_device_add_data() instead of kbd_set_plat_data(). Remove
> definition of kbd_set_plat_data().
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  arch/arm/plat-spear/include/plat/keyboard.h |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm/plat-spear/include/plat/keyboard.h b/arch/arm/plat-spear/include/plat/keyboard.h
> index c16cc31..0562f13 100644
> --- a/arch/arm/plat-spear/include/plat/keyboard.h
> +++ b/arch/arm/plat-spear/include/plat/keyboard.h
> @@ -159,11 +159,4 @@ struct kbd_platform_data {
>  	unsigned int mode;
>  };
>  
> -/* This function is used to set platform data field of pdev->dev */
> -static inline void
> -kbd_set_plat_data(struct platform_device *pdev, struct kbd_platform_data *data)
> -{
> -	pdev->dev.platform_data = data;
> -}
> -
>  #endif /* __PLAT_KEYBOARD_H */

Hi Dmitry,

Have you applied this patch?

-- 
viresh
