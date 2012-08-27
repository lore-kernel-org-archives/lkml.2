Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab2H0Okf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 10:40:35 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56485 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936Ab2H0Oke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 10:40:34 -0400
MIME-Version: 1.0
In-Reply-To: <CA+6av4=uxu_q5U_46HtpUt=FSgbh3pZuAEY54J5_xK=MKWq-YQ@mail.gmail.com>
References: <CA+6av4=uxu_q5U_46HtpUt=FSgbh3pZuAEY54J5_xK=MKWq-YQ@mail.gmail.com>
Date: Mon, 27 Aug 2012 10:40:32 -0400
X-Google-Sender-Auth: oDAyOZMTpgpLmfuWJtHLJeUr6TY
Message-ID: <CAFtxgO536xEMjMw_D1u3utT1f1iy-6EsjcawdYvbocRxc=Wu=A@mail.gmail.com>
Subject: Re: Storage related regression in linux-next 20120824
From: Jeff Garzik <jgarzik@pobox.com>
To: Arvydas Sidorenko <asido4@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "IDE/ATA development list" <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 4:59 AM, Arvydas Sidorenko <asido4@gmail.com> wrote:
> linux-next 20120824 introduced regression on Mac mini 2011 - /root partition
> gets mounted as read-only and it stays so even when trying to reboot into
> previously working kernel. In order to make it work on older kernel again
> `fsck` needs to be executed:
> ----------------------------------------------------------------------
> Root partition uses ext4 filesystem on Intel 330 SSD connected to SATA3.
> dmesg shows that journaling was disabled:
> ----------------------------------------------------------------------
> I haven't bisected to which exactly tree introduces the regression,
> but I can tell
> that linux-next 20120813 and v3.6-rc3 work fine.

Can you pastebin 'dmesg' and 'lspci'?  Did this occur only once, or is
it reproducible?

     Jeff
