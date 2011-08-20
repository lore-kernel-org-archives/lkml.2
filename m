Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab1HTVBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 17:01:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42202 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab1HTVBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 17:01:05 -0400
MIME-Version: 1.0
Date: Sat, 20 Aug 2011 22:01:03 +0100
Message-ID: <CABcS5h1WUM-zExALjGv1z_3J5WhdH=P-VWcJq2ee8oYzD+gDyg@mail.gmail.com>
Subject: kernel 3.0.3 Cgroup regression
From: Rolando Martins <rolando.martins@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I am testing kernel 3.0.3 and I am unable to "echo 3
>cpuset.sched_relax_domain_level" (the only working values are
-1,0,1).
I was able to do it in 2.6.39.

Any clues?

Thanks,
Rolando
