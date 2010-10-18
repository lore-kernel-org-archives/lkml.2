Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546Ab0JRXLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 19:11:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:7691 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738Ab0JRXLL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 19:11:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,347,1283756400"; 
   d="scan'208";a="668597202"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Tang, Feng" <feng.tang@intel.com>
Date: Mon, 18 Oct 2010 16:11:08 -0700
Subject: RE: [RESEND PATCH] x86/mrst: add SFI platform device parsing code
Thread-Topic: [RESEND PATCH] x86/mrst: add SFI platform device parsing code
Thread-Index: ActsfjndBpYVGrqYQWOpb1DRXUN27gCmuksA
Message-ID: <43F901BD926A4E43B106BF17856F0755FD2A3FD6@orsmsx508.amr.corp.intel.com>
References: <20101014142924.12442.3219.stgit@localhost.localdomain>
 <alpine.LFD.2.00.1010151443520.2496@localhost6.localdomain6>
 <20101015160445.69d7695b@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.1010151710260.2496@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010151710260.2496@localhost6.localdomain6>
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

>-----Original Message-----
>From: Thomas Gleixner [mailto:tglx@linutronix.de]
>Sent: Friday, October 15, 2010 8:33 AM
>To: Alan Cox
>Cc: LKML; x86@kernel.org; Pan, Jacob jun
>Subject: Re: [RESEND PATCH] x86/mrst: add SFI platform device parsing
>code
>
>> I'll go over the other stuff and also kick people about dumping
>> 0.7 support.
>
I have confirmed with FW guys that it is safe to remove SFI.7 support.
Lots of the magic should vanish. Feng has a couple patches for it.

Thanks,
Jacob
