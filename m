Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171Ab1GRGoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 02:44:32 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65511 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1GRGoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 02:44:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBD+Zua+oENvJWa5B1s8JvJfF-7vc2QAJEKTOPfpao+FPg@mail.gmail.com>
References: <201107170901.00119.bvanassche@acm.org> <CAJd=RBD+Zua+oENvJWa5B1s8JvJfF-7vc2QAJEKTOPfpao+FPg@mail.gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 18 Jul 2011 08:44:11 +0200
X-Google-Sender-Auth: XTpZxIkWAk_W9Q0KH2SnPWiLf8k
Message-ID: <CAO+b5-oe8MCOUH-iNB6jJj6MPqO83Wwvj9mKfxOmMzXeAH_J4Q@mail.gmail.com>
Subject: Re: [PATCH] futex: Fix spelling in a source code comment
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 2:52 PM, Hillf Danton <dhillf@gmail.com> wrote:
> On Sun, Jul 17, 2011 at 3:01 PM, Bart Van Assche <bvanassche@acm.org> wrote:
> > Change a single occurrence of "unlcoked" into "unlocked".
> >
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>
> Good catch, Acked-by: Hillf Danton <dhillf@gmail.com>

Thanks. It's something I discovered accidentally while implementing a
ticket lock in user space
(https://bugs.kde.org/show_bug.cgi?id=270006).

Bart.
