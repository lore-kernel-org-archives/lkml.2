Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626Ab2IDUuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:50:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2IDUuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:50:04 -0400
Date: Tue, 4 Sep 2012 13:50:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: benjamin.gaignard@linaro.org
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, imre.deak@nokia.com,
        Benjamin Gaignard <benjamin.gaignard@stericsson.com>
Subject: Re: [PATCH] genalloc: add best fit algorithm
Message-Id: <20120904135003.face8508.akpm@linux-foundation.org>
In-Reply-To: <1346761229-27228-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1346761229-27228-1-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Sep 2012 14:20:29 +0200
benjamin.gaignard@linaro.org wrote:

> Allow genalloc to use another algorithm than first-fit one.
> Add a best-fit algorithm.

This changelog give nobody any reason to merge the patch.

Why was this change made?  What are its benefits?  If it's a
performance optimisation then describe the tescase and provide numbers.
If it is to address some fragmentation issue then fully describe that
issue, describe the test case and provide testing results.

