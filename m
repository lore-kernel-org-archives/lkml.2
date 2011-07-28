Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab1G1GSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 02:18:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38970 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab1G1GRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 02:17:55 -0400
MIME-Version: 1.0
In-Reply-To: <1309984979-8847-2-git-send-email-robherring2@gmail.com>
References: <1309984979-8847-1-git-send-email-robherring2@gmail.com> <1309984979-8847-2-git-send-email-robherring2@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 28 Jul 2011 14:17:33 +0800
Message-ID: <CAGsJ_4zXY4HVF6=e4w0ja90HrQzwaaokoSM6tEt06amFMZYMHg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] ARM: l2x0: Add OF based initialization
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        linux@arm.linux.org.uk, workgroup.linux@csr.com,
        Olof Johansson <olof@lixom.net>, tglx@linutronix.de,
        weizeng.he@csr.com, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/7 Rob Herring <robherring2@gmail.com>:
> From: Rob Herring <rob.herring@calxeda.com>
>
> This adds probing for ARM L2x0 cache controllers via device tree. Support
> includes the L210, L220, and PL310 controllers. The binding allows setting
> up cache RAM latencies and filter addresses (PL310 only).
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Acked-by: Barry Song <21cnbao@gmail.com>

-barry
