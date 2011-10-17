Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab1JQTKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 15:10:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37208 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab1JQTKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 15:10:34 -0400
X-Authority-Analysis: v=1.1 cv=Aw1K5MWCW/IlYLbVHOK2DHmxtnIeftPoAvmBFvlQMWA= c=1 sm=0 a=rBmysYqC3NUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VZnqvK_5opkmQwtJTZoA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1318878632.4722.6.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/2] [GIT PULL][v3.2] tracing: various fixes
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 17 Oct 2011 15:10:32 -0400
In-Reply-To: <20111017185440.GB5545@elte.hu>
References: <20111017174938.842273454@goodmis.org>
	 <20111017185440.GB5545@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 20:54 +0200, Ingo Molnar wrote:

> How about the m32r build fix? I think we should apply it to perf/core 
> if everyone else was fine with your fix.

Hmm, I saw a notice that Andrew pulled it into his -mm tree. Is it going
that way?

Thanks!

-- Steve


