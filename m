Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242Ab0G0EGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 00:06:21 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:43206 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704Ab0G0EGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 00:06:20 -0400
Message-ID: <4C4E5B1E.4040004@st.com>
Date: Tue, 27 Jul 2010 09:35:50 +0530
From: Viresh KUMAR <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.11) Gecko/20100711 Lightning/1.0b1 Thunderbird/3.0.6
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, armando.visconti@st.com,
        shiraz.hashim@st.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Linus Walleij <linus.ml.walleij@gmail.com>
Subject: Re: [PATCH resend] Watchdog: Adding support for ARM Primecell	SP805
 Watchdog
References: <1275465783-14052-1-git-send-email-viresh.kumar@st.com> <4C11B711.70907@st.com> <20100611053049.GM3788@infomag.iguana.be> <4C285A72.7030303@st.com> <20100628162430.GN3788@infomag.iguana.be> <20100718193425.GD24707@n2100.arm.linux.org.uk> <20100726184601.GS11857@infomag.iguana.be>
In-Reply-To: <20100726184601.GS11857@infomag.iguana.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/27/2010 12:16 AM, Wim Van Sebroeck wrote:
> Hi All,
> 
>>>> > > > Have you reviewed this patch or still need to look at it?
>>> > > 
>>> > > I'm chasing another bug and must admit I almost forgot about this one.
>>> > > So, yes, I still need to look at this one.
>> > 
>> > Any news on this - its still sitting in the patch system since May 31st...
>> > What do I do about it?
> Patch looks OK. Will add it to my linux-2.6-watchdog-next tree this week.

Wim,

I will send V2 of this patch, which will include modification as suggested by
Linus walleij.

Viresh.
