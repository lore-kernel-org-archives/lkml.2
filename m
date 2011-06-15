Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab1FOIKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 04:10:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab1FOIKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 04:10:15 -0400
Message-ID: <4DF868DE.9000402@redhat.com>
Date: Wed, 15 Jun 2011 16:10:06 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: netconsole regression w/ 8d8fc29d
References: <4DF8660A.8020800@redhat.com>
In-Reply-To: <4DF8660A.8020800@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年06月15日 15:58, Rik van Riel 写道:
> After commit 8d8fc29d02a33e4bd5f4fa47823c1fd386346093
> (netpoll: disable netpoll when enslave a device), it is
> no longer possible to use netconsole together with bridged
> KVM guests.
>
> I can see why the change looked reasonable from a networking
> point of view, but this has completely disabled netconsole
> functionality for a common KVM use case.
>
> After the change, netconsole refuses to bind to eth0.
>
> Since the bridge interface does not support polling,
> netconsole cannot use that, either.


Bridge does support polling now. :) You can just setup
netconsole on a bridge device.

Thanks.
