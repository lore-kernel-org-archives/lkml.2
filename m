Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab2LPErx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 23:47:53 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:34826 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2LPErw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 23:47:52 -0500
MIME-Version: 1.0
In-Reply-To: <1355591803.23863.3.camel@findus-T530>
References: <1355591803.23863.3.camel@findus-T530>
Date: Sun, 16 Dec 2012 12:47:51 +0800
Message-ID: <CAJd=RBAN3KDauKw1Qy9MNXAZnkbewe5AtWOPif6aYH2CbOc3Tg@mail.gmail.com>
Subject: Re: [ANNOUNCE] Multiple run-queues for BFS
From: Hillf Danton <dhillf@gmail.com>
To: Matthias Kohler <matthias.kohler2224@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel@kolivas.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 1:16 AM, Matthias Kohler
<matthias.kohler2224@gmail.com> wrote:
> I'm doing a CPU-Scheduler based on BFS by Con Kolivas with support for
> multiple run-queues. BFS in itself uses only one run-queue for all
> CPU's. This avoids the load-balancing overhead, but does not scale well.
> One run-queue per CPU does scale well, but then the scheduler has
> load-balancing overhead. The scheduler I'm developing supports every
> possible run-queues configuration. You can have one single run-queue
> like in BFS, or you can have one run-queue per CPU, or something
> completely different like one run-queue every two CPU's. This, in theory
> would  allow the scheduler to be fine-tuned to the hardware and the
> workload.

Cannot see the reason to install wings on horse back.
Is it developed to schedule apps on advanced servers?
Notebook, or smart phone?

Good Weekend
Hillf
