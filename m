Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357Ab2HXP6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 11:58:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35900 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab2HXP6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 11:58:51 -0400
Message-ID: <5037A4B0.3080208@lwfinger.net>
Date: Fri, 24 Aug 2012 10:58:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: eric.dumazet@gmail.com, ncardwell@google.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Regression associated with commit c8628155ece3 - "tcp: reduce
 out_of_order memory use"
References: <50369925.3050705@lwfinger.net> <1345757200.5904.1890.camel@edumazet-glaptop> <50378B35.80307@lwfinger.net> <20120824.111948.680531915905273128.davem@davemloft.net>
In-Reply-To: <20120824.111948.680531915905273128.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 10:19 AM, David Miller wrote:
>
> This looks like full-on data corruption to me.

I agree. The question is why does it happen with r8712u, and only after the 
commit in the subject. Drivers for other devices that I have are OK. Thus far, I 
have tested b43, rtl8187, ath9k_htc, and rtl8192cu. To my knowledge, there are 
no reports posted for this bug with any other device.

Larry




