Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab0HNANf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 20:13:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932183Ab0HNANe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 20:13:34 -0400
MIME-Version: 1.0
In-Reply-To: <t5mb661vmb2a33gev3tqki89410a0795kc@4ax.com>
References: <20100813214704.GA18960@kroah.com> <p5ib66db7ilijjesu4dd3b351dtmsk175f@4ax.com>
 <20100813230712.GA1703@suse.de> <t5mb661vmb2a33gev3tqki89410a0795kc@4ax.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Aug 2010 17:12:57 -0700
Message-ID: <AANLkTimruyaAB-raY2ywqPQSR-h+yp7tME=eTKngcMQm@mail.gmail.com>
Subject: Re: [0/3] 2.6.27.52 stable review
To: Grant Coady <gcoady.lk@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 4:47 PM, Grant Coady <gcoady.lk@gmail.com> wrote:
>
> Machine is running, but there's a lot of these in the dmesg:
>
> WARNING: at include/linux/security.h:1826 acct_stack_growth+0xe7/0xf0()

That would seem to be because of the lack of commit 05fa199d45c in
2.6.27. It got marked for stable, but probably never went so far back
as 2.6.27.

That said, I do wonder if it is worth it maintaining a 2.6.27 that the
maintainer can't even boot on his machines any more.

                   Linus
