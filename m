Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab1D0AM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 20:12:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab1D0AM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 20:12:57 -0400
Date: Tue, 26 Apr 2011 20:08:36 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [stable] [PATCH] [0/106] 2.6.35.13 longterm review
Message-ID: <20110426200836.249fc12d@katamari>
In-Reply-To: <20110426212.641772347@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 14:12:37 -0700 (PDT)
Andi Kleen <andi@firstfloor.org> wrote:

> 
> This is the start of the longterm review cycle for the 2.6.35.12 release.

2.6.35.13...

Please revert the two TPM patches that went in 2.6.35.12. They cause timeouts
that break suspend on a bunch of HP machines, and they were reverted before
2.6.38-final was released and therefore should have never been put in -stable.

Here are the commits that revert them:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=e58713724059da7d2982d6ad945192c8fca5b729

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=8d1dc20e8d689c7e6a0a4d2c94e36a99d5793ecb
