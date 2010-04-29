Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab0D2BjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 21:39:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:13499 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507Ab0D2BjK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 21:39:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,292,1270450800"; 
   d="scan'208";a="513465750"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: Changli Gao <xiaosuo@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mst@redhat.com" <mst@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "jdike@linux.intel.com" <jdike@linux.intel.com>
Date: Thu, 29 Apr 2010 09:38:04 +0800
Subject: RE: [RFC][PATCH v4 05/18] Add a function to indicate if device use
 	external buffer.
Thread-Topic: [RFC][PATCH v4 05/18] Add a function to indicate if device use
 	external buffer.
Thread-Index: AcrkWq0xdFRbAWM+SBiWrTHWXquuzgC4dIEg
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D7902DF999655@shsmsx502.ccr.corp.intel.com>
References: <1272187206-18534-1-git-send-email-xiaohui.xin@intel.com>
 	<1272187206-18534-2-git-send-email-xiaohui.xin@intel.com>
 	<1272187206-18534-3-git-send-email-xiaohui.xin@intel.com>
 	<1272187206-18534-4-git-send-email-xiaohui.xin@intel.com>
 	<1272187206-18534-5-git-send-email-xiaohui.xin@intel.com>
 <t2z412e6f7f1004250235ib1002b3doe604d786dadefaa5@mail.gmail.com>
In-Reply-To: <t2z412e6f7f1004250235ib1002b3doe604d786dadefaa5@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int dev_is_mpassthru(struct net_device *dev)
>
>bool return value should be better here.
>
>-- 
>Regards，
>Changli Gao(xiaosuo@gmail.com)

Thanks, would fix that.

Thanks
Xiaohui
