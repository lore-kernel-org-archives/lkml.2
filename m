Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab2ASKbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 05:31:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:56765 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab2ASKbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 05:31:17 -0500
Message-ID: <4F17F0F2.6060807@linutronix.de>
Date: Thu, 19 Jan 2012 11:31:14 +0100
From: Richard Weinberger <rw@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: Netfilter: New target: RLOG
References: <1326926610-17830-1-git-send-email-rw@linutronix.de>  <20120119091248.GA32391@1984> <4F17E0A4.9040004@linutronix.de> <1326965176.2249.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.LNX.2.01.1201191045530.27900@frira.zrqbmnf.qr>
In-Reply-To: <alpine.LNX.2.01.1201191045530.27900@frira.zrqbmnf.qr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.01.2012 10:46, Jan Engelhardt wrote:
> On Thursday 2012-01-19 10:26, Eric Dumazet wrote:
>
>> Le jeudi 19 janvier 2012 à 10:21 +0100, Richard Weinberger a écrit :
>>
>>> Yeah, I could add --ring, --ring-size and --add-timestamp to LOG.
>>> What about a rlog_common.o which can be used by ipt_LOG and ip6t_LOG?
>>>
>>
>> or merge ipt_LOG and ip6t_LOG into xt_LOG ?
>
> yes please :)

Will do.

Thanks,
//richard
