Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab1DFQqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 12:46:39 -0400
Received: from linux-sh.org ([111.68.239.195]:60467 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664Ab1DFQqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 12:46:37 -0400
Date: Thu, 7 Apr 2011 01:46:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] drivers/video/bfin-lq035q1-fb.c: introduce missing kfree
Message-ID: <20110406164617.GD11820@linux-sh.org>
References: <1301667827-20056-6-git-send-email-julia@diku.dk> <BANLkTinF-Z_1J8UiPJ0wnaDLxgHRv0MsPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinF-Z_1J8UiPJ0wnaDLxgHRv0MsPw@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 02, 2011 at 01:05:57AM -0400, Mike Frysinger wrote:
> On Fri, Apr 1, 2011 at 10:23, Julia Lawall wrote:
> > Error handling code following a kmalloc should free the allocated data.
> 
> Acked-by: Mike Frysinger <vapier@gentoo.org>

Applied, thanks.
