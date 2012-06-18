Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2FRT2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 15:28:53 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34136 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab2FRT2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 15:28:52 -0400
MIME-Version: 1.0
In-Reply-To: <4FDF4720.1010801@tilera.com>
References: <4FDF4720.1010801@tilera.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 Jun 2012 12:28:31 -0700
X-Google-Sender-Auth: thunPQfOSYgEmy82j02kGkaTKYQ
Message-ID: <CA+55aFyn61Kn4t25DS2n-ZJj2PYhDKCLLRTwcT_MQbsdMzS4vw@mail.gmail.com>
Subject: Re: [GIT PULL] tilegx ethernet driver support
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 8:20 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>
> I thought David was queueing the driver for 3.6, and he presumably thought
> all the prerequisite core tile changes were already in 3.5 :-)
>
> I'm happy to just say "oh well" and leave the tilegx network driver
> unbuildable until 3.6.

I'm certainly ok with that. Would certainly prefer it over pulling a
fair number of changes at this point.

            Linus
