Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab0ELOhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:37:33 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49715 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab0ELOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:37:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=OBwPLXF5oMR/1fi8qDXmvjrftPnJ8Sb6RyYLPRvfVcuZGAvm97SB1VsuYDZJXbTr5R
         vv/M0JdFd4nEgjvcbC4bMibrz5N8aOuB5C76zOjRVgk8FQHcH3t66Tk9+rZC0YYpLSlw
         nbYHI8prTtHBm48A9PRpUOEKBla9zjG3/nKyI=
MIME-Version: 1.0
In-Reply-To: <20100512142904Z.fujita.tomonori@lab.ntt.co.jp>
References: <20100512030350.GJ15903@laptop> <20100512122323J.fujita.tomonori@lab.ntt.co.jp> 
	<AANLkTine8JmtsUo3_z6Cwdgm3LINCkJ9jL21r9eQWRm8@mail.gmail.com> 
	<20100512142904Z.fujita.tomonori@lab.ntt.co.jp>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 12 May 2010 10:37:05 -0400
Message-ID: <AANLkTinztzZMBaSG4sTqPXw4qNjmkK6gI1KOYIDIOVVx@mail.gmail.com>
Subject: Re: [LKML] Re: [PATCH v3] ad7877: keep dma rx buffers in seperate 
	cache lines
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: npiggin@suse.de, marc@tensilica.com, dmitry.torokhov@gmail.com,
       jw@emlix.com, cl@linux.com, penberg@cs.helsinki.fi, mpm@selenic.com,
       akpm@linux-foundation.org, os@emlix.com, Michael.Hennerich@analog.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, dg@emlix.com,
       osw@emlix.com, rientjes@google.com, dbrownell@users.sourceforge.net,
       grant.likely@secretlab.ca, chris@zankel.net, Piet.Delaney@tensilica.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 01:28, FUJITA Tomonori wrote:
> I guess that it would be better to start a new thread about this issue.

will do
-mike
