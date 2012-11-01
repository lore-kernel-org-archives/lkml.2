Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab2KAFEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 01:04:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab2KAFEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 01:04:50 -0400
Message-ID: <5092039C.60009@redhat.com>
Date: Thu, 01 Nov 2012 13:07:40 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, maxk@qualcomm.com, haixiao@juniper.net,
        ernesto.martin@viasat.com, krkumar2@in.ibm.com, edumazet@google.com
Subject: Re: [net-next v4 0/7] Multiqueue support in tuntap
References: <1351488964-11109-1-git-send-email-jasowang@redhat.com> <20121030165249.4cc4d596@nehalam.linuxnetplumber.net>
In-Reply-To: <20121030165249.4cc4d596@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 07:52 AM, Stephen Hemminger wrote:
> I am testing BQL for tuntap.
> It wouldn't be hard to do BQL in the multi-queue version.

Yes, if BQL for tuntap is in first, I will rebase and convert it to 
multiqueue version.

Thanks
