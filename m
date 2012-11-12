Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2KLVxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:53:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8800 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2KLVw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:52:58 -0500
X-Authority-Analysis: v=2.0 cv=NLdXCjGg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=PLHWylJg1iEA:10 a=Q5l_aFOrfXHJa3uq024A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352757176.18025.11.camel@gandalf.local.home>
Subject: Re: ftrace next tree request
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Date: Mon, 12 Nov 2012 16:52:56 -0500
In-Reply-To: <20121113084749.a1c6f250556e28100f870e29@canb.auug.org.au>
References: <1352745934.18025.8.camel@gandalf.local.home>
	 <20121113084749.a1c6f250556e28100f870e29@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-13 at 08:47 +1100, Stephen Rothwell wrote:

> As this seems to be based on things in the tip tree, I have positioned it
> after that tree.

Yes it is. Sorry I should have reported that. But as Ingo hasn't been
seen since Oct 30th (I think he's on vacation), and my code is just
sitting in limbo on LKML, I figured I start getting it tested for 3.8, 
and not wait for Ingo to pull it into tip.

I plan on doing this for other releases too.

Thanks!

-- Steve


