Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab0DKWAF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 18:00:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55995
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978Ab0DKWAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 18:00:01 -0400
Date: Sun, 11 Apr 2010 15:00:04 -0700 (PDT)
Message-Id: <20100411.150004.104064842.davem@davemloft.net>
To: yinghai.lu@oracle.com
Cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/3] tcp: Handle CHECKSUM_PARTIAL for SYNACK packets
 for IPv4
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BC23A1C.9020607@oracle.com>
References: <20100411100902.GA20141@gondor.apana.org.au>
	<E1O0w4v-0005UZ-GF@gondolin.me.apana.org.au>
	<4BC23A1C.9020607@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai <yinghai.lu@oracle.com>
Date: Sun, 11 Apr 2010 14:07:40 -0700

> On 04/11/2010 05:15 AM, Herbert Xu wrote:
>> tcp: Handle CHECKSUM_PARTIAL for SYNACK packets for IPv4
>> 
>> This patch moves the common code between tcp_v4_send_check and
>> tcp_v4_gso_send_check into a new function __tcp_v4_send_check.
>> 
>> It then uses the new function in tcp_v4_send_synack so that it
>> handles CHECKSUM_PARTIAL properly.
>> 
> Good, three patches fix the problem.

Thanks for testing.
