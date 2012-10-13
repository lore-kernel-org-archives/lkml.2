Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab2JMNyj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 09:54:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30339 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab2JMNyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 09:54:37 -0400
X-Authority-Analysis: v=2.0 cv=BP0xXSsG c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=e42hxvA3XVAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=HBBzFCKHbM4A:10 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8 a=Rs36BD4MqjlwZeEJg2oA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=WeOa-AV5lc8A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1350136476.24256.96.camel@gandalf.local.home>
Subject: Re: [PATCH 04/25] blackfin: Use Kbuild infrastructure for kvm_para.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 13 Oct 2012 09:54:36 -0400
In-Reply-To: <201210130012.40451.vapier@gentoo.org>
References: <20121013022632.024527228@goodmis.org>
	 <20121013022953.015897288@goodmis.org>
	 <201210130012.40451.vapier@gentoo.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-13 at 00:12 -0400, Mike Frysinger wrote:
> On Friday 12 October 2012 22:26:36 Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > All the headers but kvm_para.h use the Kbuild infrastructure to
> > get to the asm-generic headers.
> 
> Acked-by: Mike Frysinger <vapier@gentoo.org>
> -mike

Thanks Mike,

Would you want to pull this patch into your tree? It's not dependent on
any of the other patches.

-- Steve


