Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab2FJM5N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 08:57:13 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:25571 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780Ab2FJM5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 08:57:12 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAI+Y1E9XQD+p/2dsb2JhbABFtFmBCIIYAQEFViIBEAsYCRYPCQMCAQIBDxgeBg0BBQIBAYd5Aw+taA2JTopGYRQBhVQDmnGFK4R9gmKBVAE
Message-ID: <4FD4993A.8040804@computer.org>
Date: Sun, 10 Jun 2012 14:55:22 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: dbaryshkov@gmail.com, slapin@ossfans.org, davem@davemloft.net,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ieee802154: verify packet size before trying to allocate
 it
References: <1339326619-1753-1-git-send-email-levinsasha928@gmail.com>
In-Reply-To: <1339326619-1753-1-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2012 01:10 PM, Sasha Levin wrote:
> Currently when sending data over datagram, the send function will attempt to
> allocate any size passed on from the userspace.
> 
> We should make sure that this size is checked and limited. The maximum size
> of an IP packet seemed like the safest limit here.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

As I understand it this issue was present in the original code that was
introduced in 2.6.31 RC1. Should this therefore be submitted to stable
(in which case David will do so)?

Commit ID 9ec7671603573ede31207eb5b0b3e1aa211b2854

Thanks, Jan
