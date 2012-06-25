Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2FYFWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 01:22:05 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46876 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab2FYFWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 01:22:02 -0400
MIME-Version: 1.0
Date: Mon, 25 Jun 2012 13:22:01 +0800
Message-ID: <CACV3sb+EqVR0Z7qtCOpFtmRS+7xvv0b4S0Jrk7o7b__89_WVcA@mail.gmail.com>
Subject: perf support user-space hw_breakpoint?
From: Jovi Zhang <bookjovi@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Does perf support user space hw_breakpoint based on per-task?

perf already support kenerl space hw_breakpoint, but there don't have
any example for
user-space hw_breakpoint in code base(and never metion it).
>From perf api point of view, it should support per-task hw_breakpoint easily.
but I still want to make sure that?(badly I don't have any linux
machine to test it now:))

Thanks.

.jovi
