Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab2GJPiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:38:07 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62627 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab2GJPiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:38:05 -0400
MIME-Version: 1.0
X-Originating-IP: [121.6.75.226]
Date: Tue, 10 Jul 2012 23:38:03 +0800
Message-ID: <CAMVG2svsDbsRfqoPL6iSg2iBZ6TU3TuzOMrF0Fhz8j9-4i4v1g@mail.gmail.com>
Subject: irqbalance beneficial these days?
From: Daniel J Blueman <daniel@quora.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems like the environment for which irqbalance was originally
designed to optimise was high-interrupt-rate workloads [1].

But, with NAPI, multiple queues, threaded/split handlers, TCP offload,
interrupt moderation, RDMA etc, does anyone know it to be beneficial
in servers over the default kernel MSI vector setup? I can see it only
being beneficial in certain specific circumstances (eg metro VoIP
router) and perhaps that's application dependent at that.

Thanks,
  Daniel

[1] https://irqbalance.org/documentation.html
-- 
Daniel J Blueman
