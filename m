Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab2JMNyG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 09:54:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33226 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab2JMNyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 09:54:03 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=__DW0lOuECQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=92jCHif2VFwA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=J1Y8HTJGAAAA:8 a=3HQX15at3h_AjQ3RdpEA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1350136440.24256.95.camel@gandalf.local.home>
Subject: Re: [PATCH 20/25] sparc: Use Kbuild infrastructure to handle
 asm-generic headers
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Date: Sat, 13 Oct 2012 09:54:00 -0400
In-Reply-To: <20121012.231941.1930318153077157651.davem@davemloft.net>
References: <20121013022632.024527228@goodmis.org>
	 <20121013022955.307620438@goodmis.org>
	 <20121012.231941.1930318153077157651.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 23:19 -0400, David Miller wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Fri, 12 Oct 2012 22:26:52 -0400
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Use Kbuild infrastructure to handle the asm-generic headers
> > and remove the wrapper headers that call them.
> > 
> > This only affects headers that do nothing but include the generic
> > equivalent. It does not touch any header that does a little more.
> > 
> > Cc: linux-kbuild@vger.kernel.org
> > Cc: sparclinux@vger.kernel.org
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

David,

Would you like to take this patch? It's not dependent on any of the
other patches. Otherwise I'll probably ask Andrew to pull it into his
tree. Or I can just set up a branch and have it go into linux-next for
the next merge window.

-- Steve


