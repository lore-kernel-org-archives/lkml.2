Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab0DKVLn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 17:11:43 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:44004 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab0DKVLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 17:11:41 -0400
Message-ID: <4BC23A1C.9020607@oracle.com>
Date: Sun, 11 Apr 2010 14:07:40 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>, davem@davemloft.net
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 1/3] tcp: Handle CHECKSUM_PARTIAL for SYNACK packets for
 IPv4
References: <20100411100902.GA20141@gondor.apana.org.au> <E1O0w4v-0005UZ-GF@gondolin.me.apana.org.au>
In-Reply-To: <E1O0w4v-0005UZ-GF@gondolin.me.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4BC23AC0.0088:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2010 05:15 AM, Herbert Xu wrote:
> tcp: Handle CHECKSUM_PARTIAL for SYNACK packets for IPv4
> 
> This patch moves the common code between tcp_v4_send_check and
> tcp_v4_gso_send_check into a new function __tcp_v4_send_check.
> 
> It then uses the new function in tcp_v4_send_synack so that it
> handles CHECKSUM_PARTIAL properly.
> 
Good, three patches fix the problem.

Thanks

Yinghai
