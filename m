Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab0KWOcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:32:25 -0500
Received: from adelie.canonical.com ([91.189.90.139]:39394 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab0KWOcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:32:24 -0500
Date: Tue, 23 Nov 2010 14:32:17 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Dave Martin <dave.martin@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Allow space before [ in the case of inline
 asm constraints
Message-ID: <20101123143217.GU6038@shadowen.org>
References: <1289909596-7317-1-git-send-email-dave.martin@linaro.org>
 <1289919612.28741.58.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289919612.28741.58.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 07:00:12AM -0800, Joe Perches wrote:
> On Tue, 2010-11-16 at 12:13 +0000, Dave Martin wrote:
> > This allows the customary syntax for declaring named arguments,
> > such as:
> > 
> >     asm ("mov %[out],%[in]" : [out] "=r" (x) : [in] "r" (y));
> 
> Andy:
> 
> Maybe it'd be better to have a checkpatch pass that does
> something similar to the c comment removal for asm blocks.
> 
> Maybe keyed on "\basm(\s+volatile){0,1}\s*" and strip
> everything in the () block that follows it.

Yeah am starting to think that whatever is in there is a different
world.

-apw
