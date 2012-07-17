Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab2GQJCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 05:02:13 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:50419 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391Ab2GQJCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 05:02:10 -0400
Message-ID: <50052A06.9080301@st.com>
Date: Tue, 17 Jul 2012 14:31:58 +0530
From: Rajeev kumar <rajeev-dlh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] snd-opti9xx: Implement suspend/resume
References: <201207170916.44277.linux@rainbow-software.org> <50052470.4060604@st.com> <201207171051.01687.linux@rainbow-software.org>
In-Reply-To: <201207171051.01687.linux@rainbow-software.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/2012 2:21 PM, Ondrej Zary wrote:
>>>   static struct pnp_card_driver opti9xx_pnpc_driver = {
>>> >  >     	.flags		= PNP_DRIVER_RES_DISABLE,
>>> >  >     	.name		= "opti9xx",
>> >
>> >  Why this is opti why not OPTi
> It's not my code. This patch is just adding suspend/resume and not changing
> anything else.
>

Oops, sorry for this comment. I thought this line is changed by you.

~Rajeev
