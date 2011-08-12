Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1HLCRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 22:17:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41570 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1HLCRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 22:17:35 -0400
MIME-Version: 1.0
In-Reply-To: <1312256727-13906-1-git-send-email-sonic.adi@gmail.com>
References: <1312256727-13906-1-git-send-email-sonic.adi@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 11 Aug 2011 22:17:14 -0400
Message-ID: <CAMjpGUeeNZ_S9hgz8pi-uTnJdcUjemuOusNa=fJ9muPPaSQLMQ@mail.gmail.com>
Subject: Re: [PATCH v2] serial:bfin_uart: Put TX IRQ in individual platform resource.
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 23:45, Sonic Zhang wrote:
> Serial TX IRQ is not RX IRQ plus 1 in some blackfin chips.
> Give individual platform resources to both TX and RX irqs.

i guess you also need to fold in Scott's recent fix and send out a v3
-mike
