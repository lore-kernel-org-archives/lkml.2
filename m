Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab0FAFbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 01:31:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:41090 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab0FAFbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 01:31:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,338,1272870000"; 
   d="scan'208";a="803573310"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: "maciej.rutecki@gmail.com" <maciej.rutecki@gmail.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 1 Jun 2010 13:31:06 +0800
Subject: RE: host panic on kernel 2.6.34
Thread-Topic: host panic on kernel 2.6.34
Thread-Index: AcsA2VV+Rv/Mrw08QBe7ytfkRT/n1gAcdHJQ
Message-ID: <BC00F5384FCFC9499AF06F92E8B78A9E062ADFC19D@shsmsx502.ccr.corp.intel.com>
References: <BC00F5384FCFC9499AF06F92E8B78A9E04DCCCE242@shsmsx502.ccr.corp.intel.com>
 <201005311752.45884.maciej.rutecki@gmail.com>
In-Reply-To: <201005311752.45884.maciej.rutecki@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> On poniedzia³ek, 24 maja 2010 o 10:23:11 Hao, Xudong wrote:
>> Hi all
>> I build latest kvm 37dec075a7854f0f550540bf3b9bbeef37c11e2a, based on
>>  kernel 2.6.34, after kvm and kvm_intel module loaded, then
>>  /etc/init.d/kvm start, a few minutes later, the system will panic.
>> 
> 
> I created a Bugzilla entry at
> https://bugzilla.kernel.org/show_bug.cgi?id=16082
> for your bug report, please add your address to the CC list in there,
> thanks! 

Thanks, Maciej. I register a account and CC myself in there.

-Xudong