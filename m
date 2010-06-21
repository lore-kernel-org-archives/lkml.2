Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab0FUUB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:01:56 -0400
Received: from saarni.dnainternet.net ([83.102.40.136]:58962 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758214Ab0FUUBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:01:54 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.36
Message-ID: <20100621230152.41123y9y8dt1v968@hayate.sektori.org>
Date: Mon, 21 Jun 2010 23:01:52 +0300
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Maxim Levitsky" <maximlevitsky@gmail.com>,
       "David Quan" <David.Quan@atheros.com>,
       "Bob Copeland" <me@bobcopeland.com>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: disable ASPM
References: <20100528100901.14580.1322.stgit@fate.lan>
	<1276806785.20754.8.camel@maxim-laptop>
	<20100618112026.17623g6uhdjk8hts@naisho.dyndns.info>
	<1276856142.9114.1.camel@maxim-laptop>
	<20100618134930.124225d4fsi8w1fk@naisho.dyndns.info>
	<1276859156.19554.2.camel@maxim-laptop>
	<AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com>
	<1276870309.23783.3.camel@maxim-laptop>
	<1276933774.16697.11.camel@maxim-laptop>
	<AANLkTimIjaxq7IDWwIl1vv93k9bNQ2i89Sb5R5TiJmmA@mail.gmail.com>
	<1277032723.9555.12.camel@maxim-laptop>
	<AANLkTim8iZmm8pEERJUsrQWOiLSjPUfCN-TFFzZZQWx2@mail.gmail.com>
In-Reply-To: <AANLkTim8iZmm8pEERJUsrQWOiLSjPUfCN-TFFzZZQWx2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:

>> Also Jussi Kivilinna said that he found that in windows .inf file there
>> are some instructions to enable L1 but not L0s.
>
> For which chipsets?

I uploaded windows driver I have to:
   
http://www.student.oulu.fi/~jukivili/ath5k/XP32_XP64_WHQL_Dri-7-6-1-149_ACU-7-0-2-48_LEAP_Acer_81024

In inf, all ASPM entries are either ASPM off or ASPM L0s:off/L1:on.  
There is also user option for changing ASPM setting with options  
L0s:off/L1:off and L0s:off/L1:on.

-Jussi


