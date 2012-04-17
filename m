Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab2DQOiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:38:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:55447 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab2DQOiy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:38:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="90032266"
From: "Tu, Xiaobing" <xiaobing.tu@intel.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
Subject: RE: [RFC 1/2] kernel patch for dump user space stack tool
Thread-Topic: [RFC 1/2] kernel patch for dump user space stack tool
Thread-Index: AQHNHFTYRi+/E8vWAU248nte6/IJp5aeg2Og
Date: Tue, 17 Apr 2012 14:38:50 +0000
Message-ID: <EE928378561BF1449699C96571234A740FCED63D@SHSMSX101.ccr.corp.intel.com>
References: <EE928378561BF1449699C96571234A740FCE3704@SHSMSX102.ccr.corp.intel.com>
 <CAF1ivSZpcrCt3_cJWZLu7f7Z-DMGhijO4gM+2MTLNQC1p8=A7g@mail.gmail.com>
In-Reply-To: <CAF1ivSZpcrCt3_cJWZLu7f7Z-DMGhijO4gM+2MTLNQC1p8=A7g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ming
  Thank you for you kindly advice, I just resend the main for your suggestion. :)

Br
Xiaobing


-----Original Message-----
From: Lin Ming [mailto:mlin@ss.pku.edu.cn] 
Sent: Tuesday, April 17, 2012 12:43 PM
To: Tu, Xiaobing
Cc: akpm@linux-foundation.org; mingo@elte.hu; rusty@rustcorp.com.au; a.p.zijlstra@chello.nl; linux-kernel@vger.kernel.org; yanmin_zhang@linux.intel.com; rostedt@goodmis.org; Zuo, Jiao
Subject: Re: [RFC 1/2] kernel patch for dump user space stack tool

On Wed, Apr 11, 2012 at 4:07 PM, Tu, Xiaobing <xiaobing.tu@intel.com> wrote:
> From: xiaobing tu <xiaobing.tu@intel.com>
>
> Here is the kernel patch for this tool, The idea is to output user space stack call-chain from /proc/xxx/stack, currently, /proc/xxx/stack only output kernel stack call chain. We extend it to output user space call chain in hex format

The log is too long on a single line.
You should split it to multiple lines.

Lin Ming
