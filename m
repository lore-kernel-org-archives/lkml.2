Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab0JLB0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 21:26:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:12197 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559Ab0JLB0g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 21:26:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,317,1283756400"; 
   d="scan'208";a="615753293"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "herbert@gondor.apana.org.au" <herbert@gondor.hengli.com.au>,
        "jdike@linux.intel.com" <jdike@linux.intel.com>
Date: Tue, 12 Oct 2010 09:24:48 +0800
Subject: RE: [PATCH v12 06/17] Use callback to deal with skb_release_data()
 specially.
Thread-Topic: [PATCH v12 06/17] Use callback to deal with skb_release_data()
 specially.
Thread-Index: ActpWunL9sQwVlQYTse9WAoKX6YmJQAUUAoQ
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D793064B2AC43@shsmsx502.ccr.corp.intel.com>
References: <f2bf65a8a7676bbd3e8a749ae93d99e88671d35d.1285853725.git.xiaohui.xin@intel.com>
	 <20101001.001439.85411154.davem@davemloft.net>
	 <F2E9EB7348B8264F86B6AB8151CE2D793064B2A9D8@shsmsx502.ccr.corp.intel.com>
	 <20101011.082728.193709462.davem@davemloft.net>
 <1286811731.2737.28.camel@edumazet-laptop>
In-Reply-To: <1286811731.2737.28.camel@edumazet-laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Eric Dumazet [mailto:eric.dumazet@gmail.com]
>Sent: Monday, October 11, 2010 11:42 PM
>To: David Miller
>Cc: Xin, Xiaohui; netdev@vger.kernel.org; kvm@vger.kernel.org;
>linux-kernel@vger.kernel.org; mst@redhat.com; mingo@elte.hu;
>herbert@gondor.apana.org.au; jdike@linux.intel.com
>Subject: Re: [PATCH v12 06/17] Use callback to deal with skb_release_data() specially.
>
>Le lundi 11 octobre 2010 à 08:27 -0700, David Miller a écrit :
>> From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
>> Date: Mon, 11 Oct 2010 15:06:05 +0800
>>
>> > That's to avoid the new cache miss caused by using destructor_arg in data path
>> > like skb_release_data().
>> > That's based on the comment from Eric Dumazet on v7 patches.
>>
>> Thanks for the explanation.
>
>Anyway, frags[] must be the last field of "struct skb_shared_info"
>since commit fed66381 (net: pskb_expand_head() optimization)
>
>It seems Xin worked on a quite old tree.
>
>
I will rebase soon.

Thanks
Xiaohui
