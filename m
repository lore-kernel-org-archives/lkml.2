Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab3AGMcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 07:32:17 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:45686 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab3AGMcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 07:32:16 -0500
MIME-Version: 1.0
In-Reply-To: <50EA01BC.2080001@fold.natur.cuni.cz>
References: <50EA01BC.2080001@fold.natur.cuni.cz>
Date: Mon, 7 Jan 2013 20:32:15 +0800
Message-ID: <CAJd=RBCqZj01PPzZnxfYtxJtst6nbpuFG8x2wDhmYk=4XrqCXw@mail.gmail.com>
Subject: Re: linux-3.7.1: OOPS in page_lock_anon_vma
From: Hillf Danton <dhillf@gmail.com>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Greg KH <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Martin

On Mon, Jan 7, 2013 at 6:59 AM, Martin Mokrejs
<mmokrejs@fold.natur.cuni.cz> wrote:
> time to time. With ondemand governor I had cores in C7 for 50-70% of the time, that was
> a bit better with performance governor but having the two hyperthreaded cores disabled
> reduced the context switches by half, rescheduling interrupts went down by several orders
> of magnitute. So it is crunching at max turbo speed on both cores, temp about 80 oC.
>
Your boxen could be used to cook pizza, and check the
recommended working temperature in the manual please.

Hillf
