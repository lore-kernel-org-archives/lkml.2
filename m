Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab2JRSE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 14:04:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11091 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932725Ab2JRSE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 14:04:56 -0400
X-Authority-Analysis: v=2.0 cv=IZ4FqBWa c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=B91VBO2a_qwA:10 a=c7QpnVTx6xIA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=_Pjek1p4V8oA:10 a=wLd2_EhOBAfv83gkEDkA:9 a=CjuIK1q_8ugA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Date: Thu, 18 Oct 2012 14:04:53 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@localhost.localdomain
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Christoph Lameter <cl@linux.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [ 004/120] slab: fix the DEADLOCK issue on l3 alien lock
In-Reply-To: <20121018171411.GC23278@kroah.com>
Message-ID: <alpine.DEB.2.02.1210181401210.376@localhost.localdomain>
References: <20121011005825.364610894@linuxfoundation.org> <20121011005826.156478516@linuxfoundation.org> <20121018132020.GB7282@home.goodmis.org> <20121018171411.GC23278@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 18 Oct 2012, Greg Kroah-Hartman wrote:

>>> Michael traced the problem back to a commit in release 3.0.0:
>>
>> I don't see this fix in the last 3.0 stable release. Shouldn't it go
>> there too?
>
> As-is, it doesn't apply at all.  If someone provides me a backport, I'll
> be glad to apply it there.
>

Ug, it seems that the bug isn't in 3.0 :-/

I was looking at a diff and interpreted it incorrectly. The bug doesn't 
look to be in 3.0.

Sorry for the noise.

-- Steve
