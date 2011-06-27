Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021Ab1F0LPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 07:15:21 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:38178 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757340Ab1F0LNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 07:13:48 -0400
Message-ID: <4E086590.8080100@st.com>
Date: Mon, 27 Jun 2011 16:42:16 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: "arnd@arndb.de" <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 0/3] Add drivers/pwm and drivers/pwm/st_pwm.c
References: <cover.1306831238.git.viresh.kumar@st.com>
In-Reply-To: <cover.1306831238.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2011 02:21 PM, Viresh KUMAR wrote:
> This patchset adds drivers/pwm directory as suggested by Arnd Bergmann in
> following discussion:
> 
> http://comments.gmane.org/gmane.linux.ports.arm.kernel/118651
> 
> and also adds support for ST Microelectronics Pulse Width Modulator. This is
> currently used by ST's SPEAr platform and tested on the same.
> 
> Changes since V1:
>  - Moved driver to drivers/pwm/ directory from drivers/misc
>  - arch/arm/configs/spear3xx_defconfig updated accordingly.
> 
> Changes since earlier patchset:
>  - Moved driver to drivers/misc/ directory.
> 
> It was earlier reviewed as part of following patchset:
> "[PATCH V6 00/17] Adding devices support for all spear machines"
> 
> Viresh Kumar (3):
>   drivers/pwm st_pwm: Add support for ST's Pulse Width Modulator
>   SPEAr3xx: Add machine support for ST's PWM IP
>   SPEAr3xx: Update defconfig for ST's PWM
> 

Hi Arnd,

Will you push this patchset through your tree or somebody else will do?

-- 
viresh
