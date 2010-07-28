Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab0G1IPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 04:15:24 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:48589 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206Ab0G1IPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 04:15:21 -0400
Message-ID: <4C4FE70A.70101@st.com>
Date: Wed, 28 Jul 2010 13:45:06 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.11) Gecko/20100711 Lightning/1.0b1 Thunderbird/3.0.6
MIME-Version: 1.0
To: rd bairva <rbairva@gmail.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: JPEG hw decoder
References: <AANLkTin4r_NrQbzXoTWoJJRCUXX9mjfgtrJ9yTPLW5_W@mail.gmail.com>
In-Reply-To: <AANLkTin4r_NrQbzXoTWoJJRCUXX9mjfgtrJ9yTPLW5_W@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/2010 10:42 AM, rd bairva wrote:
> Hi ,
>       My board has a hardware JPEG decoder. I want to write a driver
> for this in Linux kernel, But it seems there that no Framework exists
> in kernel. Can somebody provide me some pointers?

Hello Rbairva,

Which JPEG decoder are you working on??

I have Synopsys JPEG Decoder/Encoder on ST SPEAr platform
and i am currently working on its driver for LKML.

I already have a driver for it which is not aligned to LKML guidelines,
and so doing modifications there.
In my driver i have used char device framework and none other suits it well.

viresh.
