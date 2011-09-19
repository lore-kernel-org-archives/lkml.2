Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab1ISJln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 05:41:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab1ISJlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 05:41:42 -0400
Message-ID: <4E770EF5.90705@redhat.com>
Date: Mon, 19 Sep 2011 17:44:21 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110126 Red Hat/3.1.8-1.el6 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: krkumar2@in.ibm.com, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, davem@davemloft.net,
        kvm@vger.kernel.org, rusty@rustcorp.com.au, qemu-devel@nongnu.org,
        mirq-linux@rere.qmqm.pl, joe@perches.com, shemminger@vyatta.com
Subject: Re: [net-next RFC V2 PATCH 0/5] Multiqueue support in tun/tap
References: <20110917055639.32666.89940.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com> <20110917191709.GA6127@redhat.com>
In-Reply-To: <20110917191709.GA6127@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2011 03:17 AM, Michael S. Tsirkin wrote:
> On Sat, Sep 17, 2011 at 02:02:04PM +0800, Jason Wang wrote:
>> A wiki-page was created to narrate the detail design of all parts
>> involved in the multi queue implementation:
>> http://www.linux-kvm.org/page/Multiqueue and some basic tests result
>> could be seen in this page
>> http://www.linux-kvm.org/page/Multiqueue-performance-Sep-13. I would
>> post the detail numbers in attachment as the reply of this thread.
> Does it make sense to test both with and without RPS in guest?
>
I've tested with RPS in guest, but didn't see improvements.
