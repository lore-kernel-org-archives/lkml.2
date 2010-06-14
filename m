Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab0FNTNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 15:13:53 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:46753 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753378Ab0FNTNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 15:13:51 -0400
From: Matt Fleming <matt@console-pimps.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-arch@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       linux-kernel@vger.kernel.org,
       Parisc List <linux-parisc@vger.kernel.org>
Subject: Re: [PATCH 4/5] parisc: Remove *(.text.*) pattern from the linker script
In-Reply-To: <1276528859.5374.29.camel@mulgrave.site>
References: <1276519112-11649-1-git-send-email-matt@console-pimps.org> <1276519112-11649-4-git-send-email-matt@console-pimps.org> <1276528859.5374.29.camel@mulgrave.site>
User-Agent: Notmuch/0.3.1-61-g3f63bb6 (http://notmuchmail.org) Emacs/23.1.90.2 (x86_64-unknown-linux-gnu)
Date: Mon, 14 Jun 2010 20:13:50 +0100
Message-ID: <877hm1zatt.fsf@linux-g6p1.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010 10:20:59 -0500, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> This would destroy all of the named parisc text ordering we do above the
> removed line because now you'd have swept up all the function sections
> before we get to them, won't it?

Argh, sorry, you're completely right. I was a bit overzealous with this
change. I'll drop it. In fact, given the very specific things that
parisc does with the .text.* sections, this entire series makes no sense
- it doesn't make sense to change TEXT_TEXT in a way that means parisc
can no longer use it.

Thanks for the review, James.
