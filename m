Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2DWMGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:06:25 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54282 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab2DWMGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:06:24 -0400
MIME-Version: 1.0
Date: Mon, 23 Apr 2012 15:06:23 +0300
Message-ID: <CAFp-nYiwbo8nS43Q1cmPChyYec1R3uH6M70dHKisubKesvxC9A@mail.gmail.com>
Subject: Why does Ksoftirqd use my whole cpu after resuming, and nobody solve
 that for 3-4 years ?
From: Servet Portakal <servetportakal@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I wanna ask two question. Why do Ksoftirqd and Kworker use whole of
one core of my cpu after resuming from suspend or hibernate? and why
nobody solve that for 3-4 years ? I can't use linux regularly because
of the issue. Please help...!!

To see my bug report, please search that title on google "[BUG]
Ksoftirqd and kworker use %100 of the cpu after resuming from the
suspend and the hibernation mode"

Thanks,
Servet.
