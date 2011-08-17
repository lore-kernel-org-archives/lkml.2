Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab1HQJsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 05:48:10 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:55528 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751618Ab1HQJsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 05:48:07 -0400
Subject: Re: avr32: handle_signal() bug?
From: Matt Fleming <matt@console-pimps.org>
To: =?ISO-8859-1?Q?H=E5vard?= Skinnemoen <hskinnemoen@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <CAF8ieYW+VC8kp10zuo8EpXXVB3vyLwGODSYFiK1xw25Z=pJMPw@mail.gmail.com>
References: <1312362279.10579.38.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAF8ieYU2ThME1Q3u6xOp0sVOh-dPep-874TDY-=-q9E3OiSQAg@mail.gmail.com>
	 <1312799149.10579.109.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAF8ieYV_3skMFo4Mc59hX1g1tFEjg8Fjnag36ZQwU9w=CPkLLQ@mail.gmail.com>
	 <1313488648.3436.126.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20110816153938.GA20428@redhat.com>
	 <CAF8ieYW+VC8kp10zuo8EpXXVB3vyLwGODSYFiK1xw25Z=pJMPw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Aug 2011 10:48:02 +0100
Message-ID: <1313574482.3436.227.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-16 at 22:14 -0700, Håvard Skinnemoen wrote:
> 
> For now, please feel free to add
> 
> Acked-by: Havard Skinnemoen <hskinnemoen@gmail.com>
> 
> to the two patches Matt sent earlier. I think they move things in the
> right direction even though there are other issues that need to be
> fixed as well.

Thanks Håvard! I've added your Acked-by's.

-- 
Matt Fleming, Intel Open Source Technology Center

