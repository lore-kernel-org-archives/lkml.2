Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043Ab1CSX0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 19:26:00 -0400
Received: from www.tglx.de ([62.245.132.106]:43697 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801Ab1CSXZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 19:25:58 -0400
Date: Sun, 20 Mar 2011 00:25:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Morris <jmorris@namei.org>
cc: John Johansen <john.johansen@canonical.com>,
        Kees Cook <kees.cook@canonical.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 0/3] security: Yama LSM
In-Reply-To: <alpine.LRH.2.00.1103171120590.31128@tundra.namei.org>
Message-ID: <alpine.LFD.2.00.1103200022210.2787@localhost6.localdomain6>
References: <1300237742-23415-1-git-send-email-kees.cook@canonical.com> <20110316013527.GQ5466@outflux.net> <4D80F59D.6000603@canonical.com> <alpine.LRH.2.00.1103171120590.31128@tundra.namei.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011, James Morris wrote:
> Personally, I'd like to see the kernel offer as much hardening as possible 
> for the general case, but this kind of work especially needs to be 
> incorporated with full buy-in from core developers.

And for that purpose it would be useful to see the actual
patches. Looks like they got submitted only to the obscurity
mailinglist.

Thanks,

	tglx
