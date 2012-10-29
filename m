Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab2J2GA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 02:00:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab2J2GA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 02:00:56 -0400
Message-ID: <508E1C44.9070405@redhat.com>
Date: Mon, 29 Oct 2012 14:03:48 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121017 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, maxk@qualcomm.com, haixiao@juniper.net,
        ernesto.martin@viasat.com, krkumar2@in.ibm.com, edumazet@google.com
Subject: Re: [PATCH] tuntap: choose the txq based on rxq
References: <1351488964-11109-1-git-send-email-jasowang@redhat.com> <1351488964-11109-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1351488964-11109-2-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 01:35 PM, Jason Wang wrote:
> This patch implements a simple multiqueue flow steering policy - tx follows rx
> for tun/tap. The idea is simple, it just choose the txq based on which rxq it
> comes. The flow were identified through the rxhash of a skb, and the hash to
> queue mapping were recorded in a hlist with an ageing timer to retire the
> mapping. The mapping were created when tun receives packet from userspace, and
> was quired in .ndo_select_queue().
>
> I run co-current TCP_CRR test and didn't see any mapping manipulation helpers in
> perf top, so the overhead could be negelected.
>
> Signed-off-by: Jason Wang<jasowang@redhat.com>

Sorry, send the wrong patch, please ignore this patch.
