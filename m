Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626Ab2HJO0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:26:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758259Ab2HJO0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:26:44 -0400
Date: Fri, 10 Aug 2012 10:26:41 -0400
From: David Teigland <teigland@redhat.com>
To: Ying Xue <ying.xue@windriver.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dlm: convert add_sock routine return value type to void
Message-ID: <20120810142641.GB31288@redhat.com>
References: <1344581922-19619-1-git-send-email-ying.xue@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344581922-19619-1-git-send-email-ying.xue@windriver.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 02:58:42PM +0800, Ying Xue wrote:
> Since add_sock() always returns a success code - 0, its return
> value type should be changed from integer to void.

Thanks, I've pushed those to my next branch.
Dave
