Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499Ab1BXEqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 23:46:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45431 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab1BXEqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 23:46:53 -0500
Message-ID: <4D65E2B4.1010501@zytor.com>
Date: Wed, 23 Feb 2011 20:46:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: =?UTF-8?B?TGludXMgTMO8c3Npbmc=?= <linus.luessing@web.de>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Multicast snooping fixes and suggestions
References: <1297811961-19249-1-git-send-email-linus.luessing@web.de> <4D65CD81.4070203@zytor.com> <20110224040412.GA25488@gondor.apana.org.au>
In-Reply-To: <20110224040412.GA25488@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2011 08:04 PM, Herbert Xu wrote:
> On Wed, Feb 23, 2011 at 07:16:17PM -0800, H. Peter Anvin wrote:
>>
>> Are these packets likely to address that situation (or am I just plain
>> doing something stupid)?
> 
> No these patches deal with IPv6 multicast support in the bridge and
> are not related to your problem.
> 
> If you're using the bridge for virtualisation and you know that
> you don't have a loop in your setup, then one option would be to
> disable STP on your bridge.

Hi,

I have disabled STP on the bridge; it doesn't change the behavior.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

