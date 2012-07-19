Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab2GSXWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 19:22:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57932 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab2GSXWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 19:22:46 -0400
Date: Thu, 19 Jul 2012 16:20:32 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: pstore/ram: Add ftrace messages handling
Message-ID: <20120719232030.GA2573@lizard>
References: <20120719142856.GA25184@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120719142856.GA25184@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Thu, Jul 19, 2012 at 05:28:56PM +0300, Dan Carpenter wrote:
> The patch a694d1b5916a: "pstore/ram: Add ftrace messages handling" 
> from Jul 9, 2012, leads to the following Smatch complaint:

A nice tool. The homepage of Smatch doesn't explicitly say that, so
I have to ask: is it a complete superset of sparse (i.e. does it
produce all the warnings that the pure sparse can produce)?
If so, I'll probably switch to it from the vanilla sparse.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
