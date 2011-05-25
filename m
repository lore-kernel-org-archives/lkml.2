Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab1EYJb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:31:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54640 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752612Ab1EYJb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:31:28 -0400
Date: Wed, 25 May 2011 17:31:23 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, grant@secretlab.ca,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: Hook up gpiolib support
Message-ID: <20110525093122.GD10526@opensource.wolfsonmicro.com>
References: <1305752282-10401-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110524162702.06b4bdb4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110524162702.06b4bdb4.akpm@linux-foundation.org>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 04:27:02PM -0700, Andrew Morton wrote:

> I got a great pile of build errors.

Oh dear, sorry about that (as you can clearly see I didn't have an Alpha
toolchain) and thanks for fixing.
