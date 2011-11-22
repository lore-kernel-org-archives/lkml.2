Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab1KVNEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 08:04:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52087 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755187Ab1KVNEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 08:04:36 -0500
Date: Tue, 22 Nov 2011 13:04:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, anaghi@mail.gnudd.com,
        balbi@ti.com
Subject: Re: [PATCH V2 0/2] debugfs: a tool to print 32-bit registers
Message-ID: <20111122130433.GC21029@opensource.wolfsonmicro.com>
References: <20111118002049.GA24806@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111118002049.GA24806@mail.gnudd.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 01:20:49AM +0100, Alessandro Rubini wrote:

> Mark, if you say this is not useful at this point, I'm fine with it; I
> may return with some regbase-aware code when time permits if it's not
> already there.

We definitely can't just use this directly with regmap as regmap is for
non memory mapped devices and makes some assumptions in that regard.  I
was mostly just suggesting that we try to keep the file formats similar
to make life easier for userspace.
