Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab2J3Xxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 19:53:43 -0400
Received: from mail.vyatta.com ([76.74.103.46]:56309 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab2J3Xxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 19:53:41 -0400
Date: Tue, 30 Oct 2012 16:52:49 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, maxk@qualcomm.com, haixiao@juniper.net,
        ernesto.martin@viasat.com, krkumar2@in.ibm.com, edumazet@google.com
Subject: Re: [net-next v4 0/7] Multiqueue support in tuntap
Message-ID: <20121030165249.4cc4d596@nehalam.linuxnetplumber.net>
In-Reply-To: <1351488964-11109-1-git-send-email-jasowang@redhat.com>
References: <1351488964-11109-1-git-send-email-jasowang@redhat.com>
Organization: Vyatta
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am testing BQL for tuntap.
It wouldn't be hard to do BQL in the multi-queue version.
