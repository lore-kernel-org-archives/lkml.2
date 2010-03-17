Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab0CQCVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 22:21:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:57264 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab0CQCVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 22:21:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,654,1262592000"; 
   d="scan'208";a="501227607"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: David Miller <davem@davemloft.net>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
Date: Wed, 17 Mar 2010 10:21:05 +0800
Subject: RE: host panic based on kernel 2.6.34-RC1
Thread-Topic: host panic based on kernel 2.6.34-RC1
Thread-Index: AcrFeA9N5PcXMZ5DQ1GR5iiVYAeNogAAGU1Q
Message-ID: <EB8593BCECAB3D40A8248BE0B6400A38464AED8D@shzsmsx502.ccr.corp.intel.com>
References: <EB8593BCECAB3D40A8248BE0B6400A38464AED81@shzsmsx502.ccr.corp.intel.com>
 <20100316.191812.86986193.davem@davemloft.net>
In-Reply-To: <20100316.191812.86986193.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: "Hao, Xudong" <xudong.hao@intel.com>
> Date: Wed, 17 Mar 2010 10:14:50 +0800
> 
>> I installed a latest kvm based on kernel 2.6.34-rc1, after I load
>> kvm kvm_i= ntel module, and start /etc/init.d/kvm, a few minutes
>> later, the system wil= l panic. The panic is easy to reproduce when
>> I use tcpdump in host. However, if I stop /etc/init.d/kvm,
>>  everything is OK, host works fine. Does= anyone met similar issue?
>> any hint? 
> 
> This is fixed in Linus's GIT tree already.

Thanks David.

Thanks,
Xudong