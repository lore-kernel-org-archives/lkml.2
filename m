Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab1B1Dck (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 22:32:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab1B1Dcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 22:32:39 -0500
Message-ID: <4D6B1742.6030108@redhat.com>
Date: Mon, 28 Feb 2011 11:32:18 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, nhorman@redhat.com,
        herbert@gondor.hengli.com.au, nhorman@tuxdriver.com,
        eric.dumazet@gmail.com, netdev@vger.kernel.org
Subject: Re: [V4 PATCH 3/3] bond: service netpoll arp queue on master device
References: <1298022215-21059-1-git-send-email-amwang@redhat.com>	<1298022215-21059-3-git-send-email-amwang@redhat.com> <20110227.161225.200373200.davem@davemloft.net>
In-Reply-To: <20110227.161225.200373200.davem@davemloft.net>
Content-Type: multipart/mixed;
 boundary="------------000104060508000508040909"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000104060508000508040909
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

于 2011年02月28日 08:12, David Miller 写道:
> From: Amerigo Wang<amwang@redhat.com>
> Date: Fri, 18 Feb 2011 17:43:34 +0800
>
>> Neil pointed out that we can't send ARP reply on behalf of slaves,
>> we need to move the arp queue to their bond device.
>>
>> Signed-off-by: WANG Cong<amwang@redhat.com>
>
> Applied.

Oops! Just found that this one I sent was not a refreshed patch.
Please discard this one, and use the one below, that is the
correct one in my git tree and the one that I tested.

Sorry for this.

----

Signed-off-by: WANG Cong <amwang@redhat.com>

--------------000104060508000508040909
Content-Type: text/plain;
 name="bond-move-arp-queue-to-master.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="bond-move-arp-queue-to-master.diff"

ZGlmZiAtLWdpdCBhL25ldC9jb3JlL25ldHBvbGwuYyBiL25ldC9jb3JlL25ldHBvbGwuYwpp
bmRleCBmNjhlNjk0Li4wNmJlMjQzIDEwMDY0NAotLS0gYS9uZXQvY29yZS9uZXRwb2xsLmMK
KysrIGIvbmV0L2NvcmUvbmV0cG9sbC5jCkBAIC0xOTMsNiArMTkzLDE3IEBAIHZvaWQgbmV0
cG9sbF9wb2xsX2RldihzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQogCiAJcG9sbF9uYXBpKGRl
dik7CiAKKwlpZiAoZGV2LT5wcml2X2ZsYWdzICYgSUZGX1NMQVZFKSB7CisJCWlmIChkZXYt
Pm5waW5mbykgeworCQkJc3RydWN0IG5ldF9kZXZpY2UgKmJvbmRfZGV2ID0gZGV2LT5tYXN0
ZXI7CisJCQlzdHJ1Y3Qgc2tfYnVmZiAqc2tiOworCQkJd2hpbGUgKChza2IgPSBza2JfZGVx
dWV1ZSgmZGV2LT5ucGluZm8tPmFycF90eCkpKSB7CisJCQkJc2tiLT5kZXYgPSBib25kX2Rl
djsKKwkJCQlza2JfcXVldWVfdGFpbCgmYm9uZF9kZXYtPm5waW5mby0+YXJwX3R4LCBza2Ip
OworCQkJfQorCQl9CisJfQorCiAJc2VydmljZV9hcnBfcXVldWUoZGV2LT5ucGluZm8pOwog
CiAJemFwX2NvbXBsZXRpb25fcXVldWUoKTsK
--------------000104060508000508040909--
