Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab0IGU2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 16:28:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60964 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab0IGU2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 16:28:18 -0400
X-Authority-Analysis: v=1.1 cv=2UVid5d+x37NY9sg6AthlbJk7luIC5bYp3eyRq7Iv0o= c=1 sm=0 a=p9iwd-OqUp0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VnNF1IyMAAAA:8 a=zlaBqYWg8YcFhIQcHdoA:9 a=KvdcaTatqv4qKr7XQGTeZ4lHi9EA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][kernelshark] trace-graph: Fix trace_seq free-before-use
From: Steven Rostedt <rostedt@goodmis.org>
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1283684704-5650-1-git-send-email-stefanha@linux.vnet.ibm.com>
References: <1283684704-5650-1-git-send-email-stefanha@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 07 Sep 2010 16:28:16 -0400
Message-ID: <1283891296.5133.126.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-05 at 12:05 +0100, Stefan Hajnoczi wrote:
> Commit e892161f731e958980fa977e2d7980f3cf0819ce changed trace_seq to
> dynamically expand its buffer.  In two instances the destroy function
> was called too early, causing a freed s.buffer to be used.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>

Thanks Stefan, applied!

-- Steve


