Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab2DRRFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:05:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40361 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab2DRRFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:05:40 -0400
Message-ID: <4F8EF454.9060000@zytor.com>
Date: Wed, 18 Apr 2012 10:05:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Lasse Collin <lasse.collin@tukaani.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Beulich <JBeulich@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xz: Enable BCJ filters on SPARC and 32-bit x86
References: <20120418195544.586415a6@tukaani.org>
In-Reply-To: <20120418195544.586415a6@tukaani.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 09:55 AM, Lasse Collin wrote:
> From: Lasse Collin <lasse.collin@tukaani.org>
> 
> The BCJ filters were meant to be enabled already on these
> archs, but the xz_wrap.sh script was buggy. Enabling the
> filters should give smaller kernel images.
> 
> xz_wrap.sh will now use $SRCARCH instead of $ARCH to detect
> the architecture. That way it doesn't need to care about the
> subarchs (like i386 vs. x86_64) since the BCJ filters don't
> care either.
> 
> Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
> Acked-by: Jan Beulich <jbeulich@suse.com>

Acked-by: H. Peter Anvin <hpa@zytor.com>

