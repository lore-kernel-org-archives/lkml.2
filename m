Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052Ab2J3RjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:39:06 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34465 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965012Ab2J3RjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:39:04 -0400
Date: Tue, 30 Oct 2012 10:38:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: SeongJae Park <sj38.park@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: csr: Remove struct CsrEvent
Message-ID: <20121030173859.GA5032@kroah.com>
References: <1351563973-20392-1-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351563973-20392-1-git-send-email-sj38.park@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 11:26:13AM +0900, SeongJae Park wrote:
> Nobody use struct CsrEvent. So, remove it.
> Signed-off-by: SeongJae Park <sj38.park@gmail.com>

Please put a blank line between your changelog text and your
signed-off-by line, otherwise I have to edit it and do it by hand.  I've
fixed it up this time.

thanks,

greg k-h
