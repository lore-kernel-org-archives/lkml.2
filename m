Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab2BWT2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:28:13 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34197 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736Ab2BWT2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:28:12 -0500
Date: Thu, 23 Feb 2012 19:28:10 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Bobby Powers <bobbypowers@gmail.com>
cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, davem@davemloft.net
Subject: Re: [PATCH] linux headers: include linux/types.h where appropriate
In-Reply-To: <1330023731-14043-1-git-send-email-bobbypowers@gmail.com>
Message-ID: <alpine.DEB.2.00.1202231927240.24797@skynet.skynet.ie>
References: <1330023731-14043-1-git-send-email-bobbypowers@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This silences the related header check warnings.

please fix the bug in the correct place, the drm.h header includes 
linux/types.h and this is one on purpose.

maybe expend some effort fixing the stupid tool to recurse like a normal 
preprocessor would.

Dave.
