Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab1H3Teu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:34:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42850 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754183Ab1H3Tes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:34:48 -0400
Subject: Re: [patch v2 09/35] Hexagon: Add checksum functions
From: Joe Perches <joe@perches.com>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
In-Reply-To: <20110830190800.574002538@codeaurora.org>
References: <20110830190729.923334292@codeaurora.org>
	 <20110830190800.574002538@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 12:34:47 -0700
Message-ID: <1314732887.14422.10.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 14:07 -0500, Richard Kuo wrote:
> Removed most non-assembly functions and use the generic ones instead.
[]
> +++ linux-hexagon-kernel/arch/hexagon/include/asm/checksum.h	2011-08-24 18:45:48.133877105 -0500
[]
> +#define do_csum	do_csum

That looks pretty odd.
I have a hard time believing that's useful or necessary.


