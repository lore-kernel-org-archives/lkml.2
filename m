Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab0KBNqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 09:46:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44861 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751639Ab0KBNqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 09:46:06 -0400
Date: Tue, 2 Nov 2010 09:46:13 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: regulator disable supply fix
Message-ID: <20101102134613.GF21476@opensource.wolfsonmicro.com>
References: <1288700549-28535-1-git-send-email-mattias.wallin@stericsson.com>
 <20101102131952.GC21476@opensource.wolfsonmicro.com>
 <4CD015F6.5060507@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD015F6.5060507@stericsson.com>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 02:45:26PM +0100, Mattias Wallin wrote:

> > but this does smell a bit like it ought to be in the _regulator_disable()
> > call rather than the caller.

> Would you prefer below solution instead?

Yes.
