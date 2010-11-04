Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab0KDKuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 06:50:05 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:54404 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755105Ab0KDKuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 06:50:03 -0400
Message-ID: <4CD28FA6.9030303@stericsson.com>
Date: Thu, 4 Nov 2010 11:49:10 +0100
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH] regulator: lock supply in regulator enable
References: <4CD2847B.1060009@stericsson.com> <1288865910.3277.23.camel@odin>
In-Reply-To: <1288865910.3277.23.camel@odin>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I wrote, the problem that I had is solved with my previous patch.
Right now I have no visible problem but I still think there is locks missing
and would like your opinion on it.

/Wallin

On 11/04/2010 11:18 AM, Liam Girdwood wrote:
> On Thu, 2010-11-04 at 11:01 +0100, Mattias Wallin wrote:
>> This patch add locks around regulator supply enable.
>>
>> Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
>> ---
>> The previous patch I sent solves a problem seen in our system.
>> This patch does not solve a problem I have seen but I still think
>> it should be there. Or at least some locking of the supply in regulator enable.
>> What do you guys think?
> 
> This sounds like guesswork. What exactly is the problem in your system ?
> 
> Liam
