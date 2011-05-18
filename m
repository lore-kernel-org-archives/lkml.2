Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297Ab1ERPDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:03:06 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:39654 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559Ab1ERPDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:03:05 -0400
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>
Subject: Re: [RFC 1/5] platform-drivers-x86: add support for Technologic Systems TS-5xxx detection
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Sean Young <sean@mess.org>
In-reply-to: <BANLkTikPxfq4hcSLB+xkk-oJAtouNxEoyA@mail.gmail.com>
References: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com> <1304115712-5299-2-git-send-email-vivien.didelot@savoirfairelinux.com> <BANLkTikPxfq4hcSLB+xkk-oJAtouNxEoyA@mail.gmail.com>
Date: Wed, 18 May 2011 11:03:05 -0400
Message-Id: <1305730587-sup-4689@v0nbox>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sean,
Excerpts from Sean Young's message of mar mai 17 08:37:19 -0400 2011:
> Please note that the 2MiB on board flash is not supported by your
> platform driver, which is handled by drivers/mtd/maps/ts5500_flash.c. I
> guess it would be best to either merge that file into
> drivers/platform/x86/ts5xxx-sbcinfo.c or select CONFIG_MTD_TS5500 in the
> Kconfig.
> 
> In addition, the flash is used by the BIOS as RFD FTL, so possibly
> CONFIG_RFD_FTL should be selected too.
> 
> Thanks,
> Sean
Good point. That's what I've noticed a few days ago, I'm actually
working on.

Thanks,
Vivien.
