Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab1GGAUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 20:20:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38373 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab1GGAUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 20:20:33 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <1309984979-8847-2-git-send-email-robherring2@gmail.com>
References: <1309984979-8847-1-git-send-email-robherring2@gmail.com>
	<1309984979-8847-2-git-send-email-robherring2@gmail.com>
Date: Wed, 6 Jul 2011 17:20:31 -0700
Message-ID: <CAOesGMhVuOVVeZQmt3fW3uXML0Op_f3x5e=-OeECJsWeybk9Ag@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] ARM: l2x0: Add OF based initialization
From: Olof Johansson <olof@lixom.net>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        linux@arm.linux.org.uk, Barry Song <21cnbao@gmail.com>,
        workgroup.linux@csr.com, tglx@linutronix.de, weizeng.he@csr.com,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 6, 2011 at 1:42 PM, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> This adds probing for ARM L2x0 cache controllers via device tree. Support
> includes the L210, L220, and PL310 controllers. The binding allows setting
> up cache RAM latencies and filter addresses (PL310 only).
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
