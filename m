Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab2I1OoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:44:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56332 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721Ab2I1OoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:44:15 -0400
MIME-Version: 1.0
In-Reply-To: <1348842668.1480.9.camel@anish-Inspiron-N5050>
References: <1348793563-19186-1-git-send-email-ming.lei@canonical.com>
	<CAK7N6vqS9PW85hgcA7EVzCk-TQo_ru4OcC5i0Rw-b2hvb4YoXg@mail.gmail.com>
	<CACVXFVMJaQRj6sUJwiyiMvyAyd2p_8g9cYFqRW2KngQPx62Y5A@mail.gmail.com>
	<1348842668.1480.9.camel@anish-Inspiron-N5050>
Date: Fri, 28 Sep 2012 22:44:13 +0800
Message-ID: <CACVXFVPE1wwVhN=WobgZ+KfGRk2HifQ_3bhwF4mHS+Qu+bXh+g@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix possible missing of device probe
From: Ming Lei <ming.lei@canonical.com>
To: anish kumar <anish198519851985@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 10:31 PM, anish kumar
<anish198519851985@gmail.com> wrote:

> Ming,
> Somehow I feel here that the problem reported by Russell is totally
> different from your understanding of problem.I humbly urge you to have

I let Russell answer if it is same problem, see my last email.

> a look at Russell's nice explanation.

Sorry, how do you know I didn't look at Russell's explanation?


Thanks,
--
Ming Lei
