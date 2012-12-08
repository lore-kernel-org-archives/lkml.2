Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab2LHCv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 21:51:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30897 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab2LHCvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 21:51:25 -0500
X-Authority-Analysis: v=2.0 cv=ZNdVaAHb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=9v1Bx27WI7kA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=OuX3rJNq5KYA:10 a=VnNF1IyMAAAA:8 a=dlI4R5ZWAAAA:8 a=O7y9z0SWUd8D2Mtl0o8A:9 a=CjuIK1q_8ugA:10 a=U8Vofuz5e00A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Fri, 7 Dec 2012 21:51:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Debugging: Keep track of page owners
Message-ID: <20121208025123.GB31591@home.goodmis.org>
References: <20121207212417.FAD8DAED@kernel.stglabs.ibm.com>
 <20121207142614.428b8a54.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121207142614.428b8a54.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 02:26:14PM -0800, Andrew Morton wrote:
> On Fri, 07 Dec 2012 16:24:17 -0500
> Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> 
> > To: akpm@osdl.org
> 
> It's years since I was called that.

"Help me akpm@osdl.org. You're my only hope"...

> 
> > From: mel@skynet.ie (Mel Gorman)
> 
> And him that.
> 

"mel@skynet.ie is my father!" - Luke Skynet.ie

-- Steve ;-)

