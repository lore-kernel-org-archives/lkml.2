Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405Ab2I1PAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:00:23 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:55049 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758393Ab2I1PAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:00:21 -0400
Subject: Re: [PATCH] driver core: fix possible missing of device probe
From: anish kumar <anish198519851985@gmail.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        stable@vger.kernel.org
In-Reply-To: <CACVXFVPE1wwVhN=WobgZ+KfGRk2HifQ_3bhwF4mHS+Qu+bXh+g@mail.gmail.com>
References: <1348793563-19186-1-git-send-email-ming.lei@canonical.com>
	 <CAK7N6vqS9PW85hgcA7EVzCk-TQo_ru4OcC5i0Rw-b2hvb4YoXg@mail.gmail.com>
	 <CACVXFVMJaQRj6sUJwiyiMvyAyd2p_8g9cYFqRW2KngQPx62Y5A@mail.gmail.com>
	 <1348842668.1480.9.camel@anish-Inspiron-N5050>
	 <CACVXFVPE1wwVhN=WobgZ+KfGRk2HifQ_3bhwF4mHS+Qu+bXh+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Sep 2012 20:30:05 +0530
Message-ID: <1348844405.1480.19.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-28 at 22:44 +0800, Ming Lei wrote:
> On Fri, Sep 28, 2012 at 10:31 PM, anish kumar
> <anish198519851985@gmail.com> wrote:
> 
> > Ming,
> > Somehow I feel here that the problem reported by Russell is totally
> > different from your understanding of problem.I humbly urge you to have
> 
> I let Russell answer if it is same problem, see my last email.
> 
> > a look at Russell's nice explanation.
> 
> Sorry, how do you know I didn't look at Russell's explanation?
Sorry but I just had a cursory glance at your explanation and looks like
there was some argument between you and russell so thought about
that(shamelessly not even going through the explanation put forward by
you as I understood the problem and solution). Anyway as mentioned
earlier I am no expert on driver core but just wanted to learn the
wonderful driver core design.

Hope I didn't offend you.
> 
> 
> Thanks,
> --
> Ming Lei


