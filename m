Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab0HZSZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:25:15 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43006 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab0HZSZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:25:10 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        Kevin Hilman <davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sandeep Paulraj <s-paulraj@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] arm: mach-davinci: check irq2ctlr() result
Organization: Deep Root Systems, LLC
References: <1279379947-15152-1-git-send-email-segooon@gmail.com>
Date: Thu, 26 Aug 2010 11:25:06 -0700
In-Reply-To: <1279379947-15152-1-git-send-email-segooon@gmail.com> (Kulikov
	Vasiliy's message of "Sat, 17 Jul 2010 19:19:07 +0400")
Message-ID: <87wrrd2pvh.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kulikov Vasiliy <segooon@gmail.com> writes:

> If irq2ctlr() fails return IRQ_NONE.
> Also as it can fail make 'ctlr' signed.

[...]

> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Sorry for the lag on this one.

Queueing for 2.6.37 in linux-davinci.git

Kevin
