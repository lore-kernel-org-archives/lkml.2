Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287Ab2AIVDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 16:03:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40147 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab2AIVDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 16:03:46 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=QSbh5HSzrH8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VnNF1IyMAAAA:8 a=g-yEv9SR5XLbSi0g6s8A:9 a=Q8Ai8ErUU5yHc16Fao4A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326143024.7642.39.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v2][trace-cmd] blk plugin: replace BLK_TC_BARRIER with
 BLK_TC_FLUSH/BLK_TC_FUA
From: Steven Rostedt <rostedt@goodmis.org>
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>
Date: Mon, 09 Jan 2012 16:03:44 -0500
In-Reply-To: <1326108639-13904-1-git-send-email-stefanha@linux.vnet.ibm.com>
References: <1326108639-13904-1-git-send-email-stefanha@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-09 at 11:30 +0000, Stefan Hajnoczi wrote:
> The BLK_TC_BARRIER flag was dropped in Linux commit c09c47caedc in
> August 2011.  The blk plugin fails to build against recent kernel
> headers.  Since no flag bits were left, the new BLK_TC_FLUSH flag reused
> the BLK_TC_BARRIER bit.  The new BLK_TC_FUA flag was also added.
> 
> This patch updates fill_rwbs() to reflect the new
> BLK_TC_FLUSH/BLK_TC_FUA flags.  This allows plugin_blk.c to build
> successfully on recent kernels.  Most of the patch deals with detecting
> old vs new kernel headers so we can build successfully on both.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>



Thanks, applied!

-- Steve


