Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab0ESDNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 23:13:14 -0400
Received: from mail-qy0-f171.google.com ([209.85.221.171]:37790 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab0ESDNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 23:13:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rbAclpH/N+BIKx7nOB4SIE3zfl57fVBe1falAlynNd3ALZhhX2EqARkalHNUOhtg3H
         1Ms273NGoQVzPwKUfiJRqI6WP2Dw2qiTk9cjbDRcNPe7EaZfCvH8TigPUh7wwjh3CbUD
         zWBPILk+ZrUTZdby8TmTkG51sr99sSfOPWK7E=
MIME-Version: 1.0
In-Reply-To: <20100519005032.GA26906@owl>
References: <20100510035031.GD9181@owl> <20100514065808.GA11598@owl> 
	<20100517094136.094800562@osadl.org> <AANLkTinQlH7LhCAz00WaHqbbslcSqipzVx4tDoQKSqIL@mail.gmail.com> 
	<625BA99ED14B2D499DC4E29D8138F150181F574C31@shsmsx502.ccr.corp.intel.com> 
	<AANLkTimQnaUvXs75rpTOcW7CODXWgUfzekY9FCDa5S8P@mail.gmail.com> 
	<20100519005032.GA26906@owl>
From: Dmitry Gromov <gromovd@gmail.com>
Date: Tue, 18 May 2010 23:12:51 -0400
Message-ID: <AANLkTimgz4OF48ryaLAeXmbes786iKBLT0F7_h6ytAeP@mail.gmail.com>
Subject: Re: [lm-sensors] [PATCH 0/2] hwmon: Update coretemp to current Intel 
	processors
To: Huaxu Wan <huaxu.wan@linux.intel.com>
Cc: "Wan, Huaxu" <huaxu.wan@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>, Carsten Emde <C.Emde@osadl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Tue, May 18, 2010 at 20:50, Huaxu Wan <huaxu.wan@linux.intel.com> wrote:
> On 02:45 Tue 18 May, Dmitry Gromov wrote:
>> Hi!
>>
>> And 90C seems to be good for N200 series of Atom CPUs only - I could not
>> find TjMax value published for N330 Dual Core  (quite popular one). Intel
>> only published Tcase for it:
>> http://ark.intel.com/Product.aspx?id=35641
>> So, if for N270 Tcase = TjMax = 90C, then, I'd suggest to use Tcase = 85.2C
>> for N330 TjMax value.
>
> Quoted a sentence from [1], "Unless specified otherwise, all specifications for
> the processor are at TJ = 90°C", I believe the TjMax of 330 is 90C too.
>

Well, that refers for the values in that specific table and entire
document (which I went through as well) does not specify TjMax :(
Similar document for N270 series does specify TjMax explicitly in Table 14:
http://download.intel.com/design/processor/datashts/320032.pdf

Another document, "Thermal and Mechanical Design Guidelines" for Atom
300 series:
http://download.intel.com/design/processor/designex/320530.pdf
specifies Tcase-max = 85.2C
Thinking about this a bit, I think Tcase-max should be lower than
TjMax, which probably is still 90C.
The document itself is a good reading too.

Anyway, thank you very much for your help, Huaxu!

-- 
DG
NJ
