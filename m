Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab0L2TYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 14:24:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753640Ab0L2TYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 14:24:18 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinCD5Jf-dEUpv7hu4YKrxS0DGqqqBU94iCJ8602@mail.gmail.com>
References: <AANLkTinCD5Jf-dEUpv7hu4YKrxS0DGqqqBU94iCJ8602@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Dec 2010 11:23:55 -0800
Message-ID: <AANLkTinJAEW-xAiEKnfxo1+3FiGwFXFii5Rh6d8tAtB-@mail.gmail.com>
Subject: Re: Kernel 2.6.37-rc5 rc7 Oops
To: Alex Arnautu <alex.arnautu96@gmail.com>,
        David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 4:26 AM, Alex Arnautu <alex.arnautu96@gmail.com> wrote:
>
> I get an oops with 2.6.37-rc5 and 2.6.37-rc7-git1.
> http://www.fotoshack.us/fotos/19044P271210_15.14_[01].jpg

Hmm. Davem added to the list of people involved. This _may_ be fixed
by the "always clone skbs" commit in -rc8 (commit 173021072), but
David can make a better judgment call.

Davem?

                             Linus
