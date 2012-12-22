Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab2LVEou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 23:44:50 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:59816 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab2LVEor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 23:44:47 -0500
MIME-Version: 1.0
In-Reply-To: <20121221185115.1858ffc5@annuminas.surriel.com>
References: <20121221184940.103c31ad@annuminas.surriel.com>
	<20121221185115.1858ffc5@annuminas.surriel.com>
Date: Fri, 21 Dec 2012 20:44:46 -0800
Message-ID: <CANN689E74WQfKUb+tOc=GtD6K6BGaaGgFC-NRuZyvsXtBgi1Wg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] x86,smp: proportional backoff for ticket spinlocks
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 3:51 PM, Rik van Riel <riel@redhat.com> wrote:
> Subject: x86,smp: proportional backoff for ticket spinlocks
>
> Simple fixed value proportional backoff for ticket spinlocks.
> By pounding on the cacheline with the spin lock less often,
> bus traffic is reduced. In cases of a data structure with
> embedded spinlock, the lock holder has a better chance of
> making progress.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>

Looks fine to me other than the arbitrary-ness of 50

Reviewed-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
