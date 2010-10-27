Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab0J0Vma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 17:42:30 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38023 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477Ab0J0Vm2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 17:42:28 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.188.124]
In-Reply-To: <1C13481E-69E7-4779-B472-42DD49619A89@mac.com>
References: <1C13481E-69E7-4779-B472-42DD49619A89@mac.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 27 Oct 2010 23:42:07 +0200
Message-ID: <AANLkTinzDFs5ve=aK-n=+_cxj2p3kyuZ9Dos8Td1tYT2@mail.gmail.com>
Subject: Re: wl12xx board_ref_clock
To: Elvis Dowson <elvis.dowson@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Elvis,

On Wed, Oct 27, 2010 at 7:59 PM, Elvis Dowson <elvis.dowson@mac.com> wrote:
>                  To which device does board_ref_clock refer to?

An external clock hardwired to your device. You should ask the vendor
of your board which one is it.

> On my board, the SDIO CLK line from the MMC2 controller is connected to the LSR TiWi wlan module.

This has nothing to do with the SDIO clk.

> What is the impact of not specifying a board_ref_clock?

Bad timing issues. Expect bad WLAN behavior (but not poof of smoke).

PS - please don't CC LKML on these issues. for wl1271 questions,
please CC linux-wireless

Thanks,
Ohad.
