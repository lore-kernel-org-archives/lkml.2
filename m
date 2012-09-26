Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab2IZUTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 16:19:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11405 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2IZUTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 16:19:45 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=cGHOI4EiJiIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=xcvXsrr2BTgA:10 a=HxFpDGPoftOp0VsE8u4A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348690783.22822.61.camel@gandalf.local.home>
Subject: Re: [PATCH] trace: replace strict_strto* with kstrto*
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Walter <sahne@0x90.at>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com
Date: Wed, 26 Sep 2012 16:19:43 -0400
In-Reply-To: <20120926200838.GC1244@0x90.at>
References: <20120926200838.GC1244@0x90.at>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 22:08 +0200, Daniel Walter wrote:
> [trace] replace strict_strto* with kstrto*
> 
>  * remove old string conversions with kstrto*
> 
> Signed-off-by: Daniel Walter <sahne@0x90.at>

Thanks! I'll queue it up.

-- Steve


