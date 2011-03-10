Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab1CJVa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:30:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40553 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab1CJVaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:30:25 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=gWPt9IHLA7gA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=meVymXHHAAAA:8 a=QyXUC8HyAAAA:8 a=5_cCk_V5n04vabvquSkA:9 a=-GabITsK9rgZg3lhRFPpEr55SQIA:4 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH trace-cmd v2] trace-cmd: allow setting CC and AR, or
 CROSS_COMPILE from command line
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com,
        Darren Hart <dvhart@linux.intel.com>
In-Reply-To: <1299791491-1805-1-git-send-email-dhsharp@google.com>
References: <1299780664.15854.399.camel@gandalf.stny.rr.com>
	 <1299791491-1805-1-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 16:30:23 -0500
Message-ID: <1299792624.15854.420.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 13:11 -0800, David Sharp wrote:
> Makefiles suck: Use some makefile magic to get the best of all worlds for
> CC and AR: Sane defaults and the ability to override CC, and AR, or use
> CROSS_COMPILE to set a prefix.
> 
> Signed-off-by: David Sharp <dhsharp@google.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Darren Hart <dvhart@linux.intel.com>
> ---

Applied, thanks David!

-- Steve


