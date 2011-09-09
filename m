Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab1IIQbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 12:31:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46060 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758537Ab1IIQbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 12:31:00 -0400
Date: Fri, 9 Sep 2011 09:30:57 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 1/2] regmap: Support half writes and padding between
 register and value.
Message-ID: <20110909163057.GA4070@opensource.wolfsonmicro.com>
References: <1315490964-25718-1-git-send-email-jic23@cam.ac.uk>
 <1315490964-25718-2-git-send-email-jic23@cam.ac.uk>
 <20110908162715.GB3098@opensource.wolfsonmicro.com>
 <4E69E019.6060601@cam.ac.uk>
 <20110909161418.GB3515@opensource.wolfsonmicro.com>
 <4E6A3F09.5000307@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6A3F09.5000307@cam.ac.uk>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 05:30:01PM +0100, Jonathan Cameron wrote:
> On 09/09/11 17:14, Mark Brown wrote:

> > Some devices apparently use an entire byte or word with a magic flag in
> > it to distinguish reads and writes.  These end up looking like 16 bit
> > registers with only the lower 8 bits actually used in the current code.

> Ah, fair enough there is a use case.  Can we add this as an additional patch
> when needed?

Yes, of course.  Only consideration is that the current option needs to
be clearly named to avoid colliding with such an addition.
