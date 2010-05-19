Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab0ESAug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 20:50:36 -0400
Received: from mga06.intel.com ([134.134.136.21]:7294 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751876Ab0ESAuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 20:50:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,258,1272870000"; 
   d="scan'208";a="622830983"
Date: Wed, 19 May 2010 08:50:32 +0800
From: Huaxu Wan <huaxu.wan@linux.intel.com>
To: Dmitry Gromov <gromovd@gmail.com>
Cc: "Wan, Huaxu" <huaxu.wan@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>, Carsten Emde <C.Emde@osadl.org>
Subject: Re: [lm-sensors] [PATCH 0/2] hwmon: Update coretemp to current
 Intel processors
Message-ID: <20100519005032.GA26906@owl>
References: <20100510035031.GD9181@owl>
 <20100514065808.GA11598@owl>
 <20100517094136.094800562@osadl.org>
 <AANLkTinQlH7LhCAz00WaHqbbslcSqipzVx4tDoQKSqIL@mail.gmail.com>
 <625BA99ED14B2D499DC4E29D8138F150181F574C31@shsmsx502.ccr.corp.intel.com>
 <AANLkTimQnaUvXs75rpTOcW7CODXWgUfzekY9FCDa5S8P@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimQnaUvXs75rpTOcW7CODXWgUfzekY9FCDa5S8P@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02:45 Tue 18 May, Dmitry Gromov wrote:
> Hi!
> 
> And 90C seems to be good for N200 series of Atom CPUs only - I could not
> find TjMax value published for N330 Dual Core  (quite popular one). Intel
> only published Tcase for it:
> http://ark.intel.com/Product.aspx?id=35641
> So, if for N270 Tcase = TjMax = 90C, then, I'd suggest to use Tcase = 85.2C
> for N330 TjMax value.

Quoted a sentence from [1], "Unless specified otherwise, all specifications for 
the processor are at TJ = 90°C", I believe the TjMax of 330 is 90C too.

[1]http://download.intel.com/design/processor/datashts/320528.pdf

Thanks
Huaxu
