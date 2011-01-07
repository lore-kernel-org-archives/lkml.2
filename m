Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1AGDfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 22:35:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51539 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1AGDfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 22:35:37 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=4xg72MV0qvQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=QyXUC8HyAAAA:8 a=z6gsHLkEAAAA:8 a=hkCx7ROzYOxGkqFXLYYA:9 a=oEWZ0mD9vkk1ub0oVoxup0W_angA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [[PATCH] trace-cmd: ] Use conditional assignment of CC and AR
From: Steven Rostedt <rostedt@goodmis.org>
To: Darren Hart <darren@dvhart.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Darren Hart <dvhart@linux.intel.com>, Tim Bird <tim.bird@am.sony.com>
In-Reply-To: <1294333733-7746-1-git-send-email-darren@dvhart.com>
References: <1294333733-7746-1-git-send-email-darren@dvhart.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 06 Jan 2011 22:35:33 -0500
Message-ID: <1294371333.26623.188.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 09:08 -0800, Darren Hart wrote:
> From: Darren Hart <dvhart@linux.intel.com>
> 
> Allow the user to specify CC and AR via the environment by only
> setting them in the Makefile if they don't already exist. This is
> useful for external build systems for example.
> 
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> CC: Tim Bird <tim.bird@am.sony.com>

Applied,

Thanks Darren!

-- Steve


