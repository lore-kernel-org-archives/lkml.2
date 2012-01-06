Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488Ab2AFB5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 20:57:51 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62094 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436Ab2AFB5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 20:57:50 -0500
Date: Fri, 6 Jan 2012 05:57:45 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jz4740-battery: fix signedness bug
Message-ID: <20120106015745.GB15103@oksana.dev.rtsoft.ru>
References: <1323349452.2823.1.camel@phoenix>
 <1323349526.2823.2.camel@phoenix>
 <4EE0C4F1.9080607@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4EE0C4F1.9080607@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 03:08:49PM +0100, Lars-Peter Clausen wrote:
> On 12/08/2011 02:05 PM, Axel Lin wrote:
> > wait_for_completion_interruptible_timeout() may return negative value.
> > In this case, checking if (t > 0)  will return true if t is unsigned.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
