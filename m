Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab2JMNzV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 09:55:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14408 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab2JMNzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 09:55:16 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=m7OQKA4qR7sA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=9i2n2SPYWiAA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=oB9C92iSAAAA:8 a=WbBZnhyIM_hJ91OEEAEA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1350136513.24256.97.camel@gandalf.local.home>
Subject: Re: [PATCH 15/25] openrisc: Use Kbuild infrastructure for kvm_para.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 13 Oct 2012 09:55:13 -0400
In-Reply-To: <CACM3HyHnMHj=DB5FeLUfRsKT-a=KzcmdpSbudoLU7O48RzuPoA@mail.gmail.com>
References: <20121013022632.024527228@goodmis.org>
	 <20121013022954.595178706@goodmis.org>
	 <CACM3HyHnMHj=DB5FeLUfRsKT-a=KzcmdpSbudoLU7O48RzuPoA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-13 at 08:32 +0200, Jonas Bonn wrote:
> On 13 October 2012 04:26, Steven Rostedt <rostedt@goodmis.org> wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> >
> > All the headers but kvm_para.h use the Kbuild infrastructure to
> > get to the asm-generic headers.
> >
> > Cc: linux-kbuild@vger.kernel.org
> > Cc: linux@lists.openrisc.net
> > Cc: Jonas Bonn <jonas@southpole.se>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Acked-by: Jonas Bonn <jonas@southpole.se>

Thanks Jonas,

Would you like to pull this into your tree? It's not dependent on any of
the other patches. Or I can take care of it too.

-- Steve


