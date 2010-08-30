Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab0H3Ujp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 16:39:45 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:55851 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab0H3Ujn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 16:39:43 -0400
X-SpamScore: -10
X-BigFish: VS-10(zz98dN4015Lzz1202hzz8275bhz2dh2a8h)
Message-ID: <4C7C16F8.7060905@freescale.com>
Date: Mon, 30 Aug 2010 15:39:20 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/2.0.6-1.fc13 SeaMonkey/2.0.6
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: kernel-janitors@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 5/7] arch/powerpc/sysdev/qe_lib/qe.c: Add of_node_put
 to avoid memory leak
References: <1283075566-27441-1-git-send-email-julia@diku.dk> <1283075566-27441-6-git-send-email-julia@diku.dk>
In-Reply-To: <1283075566-27441-6-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Aug 2010 20:39:20.0677 (UTC) FILETIME=[6C669950:01CB4883]
X-Reverse-DNS: az33egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> Add a call to of_node_put in the error handling code following a call to
> of_find_compatible_node.

Acked-by: Timur Tabi <timur@freescale.com>

Thanks, Julia.  Your work in finding these kinds of bugs is very much
appreciated.


