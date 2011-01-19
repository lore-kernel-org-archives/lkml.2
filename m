Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1ASNQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 08:16:27 -0500
Received: from webmail10.mail.sp.isp-net.nl ([217.149.192.62]:36719 "EHLO
	webmail10.mail.sp.isp-net.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188Ab1ASNQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 08:16:26 -0500
Message-ID: <4D36E461.8060305@xmsnet.nl>
Date: Wed, 19 Jan 2011 14:17:21 +0100
From: Hans de Bruin <jmdebruin@xmsnet.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101125 Thunderbird/3.0.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [regression] 2.6.37+ commit 0363466866d9.... breaks tcp ipv6
References: <4D335417.80704@xmsnet.nl>	<4D35EF64.1040906@xmsnet.nl>	 <AANLkTinejKw0pY5HncB2e0ocjqYuCwTBUwd2xkroWu+E@mail.gmail.com>	 <4D36092B.1090406@xmsnet.nl> <1295388238.8449.10.camel@edumazet-laptop>
In-Reply-To: <1295388238.8449.10.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Language-Detected: da
X-Language-Detected: fr
X-Language-Detected: ca
X-Language-Detected: en
X-Spam-Scanned: InterNLnet Mail Scan System V2.03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2011 11:03 PM, Eric Dumazet wrote:
> Le mardi 18 janvier 2011 à 22:42 +0100, Hans de Bruin a écrit :
>> On 01/18/2011 09:06 PM, Jesse Gross wrote:
>>> On Tue, Jan 18, 2011 at 11:52 AM, Hans de Bruin<jmdebruin@xmsnet.nl>   wrote:
>>>> On 01/16/2011 09:24 PM, Hans de Bruin wrote:
>>>>>
>>>>> After last nights compile i lost the possibility to connect to ssh and
>>>>> http over ipv6. The connection stops at syn_sent. connections to my
>>>>> machine end in syn_recv. ping6 still works.
>>>>>
...

Just received a fix from one of the netdev's

-- 
Hans
