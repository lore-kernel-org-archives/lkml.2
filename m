Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab1GaM6X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 08:58:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60576 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab1GaM6W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 08:58:22 -0400
MIME-Version: 1.0
In-Reply-To: <20110730225039.34467e4e@debxo>
References: <20110730225039.34467e4e@debxo>
Date: Sun, 31 Jul 2011 13:58:20 +0100
X-Google-Sender-Auth: j4RPYEyoww27DZ8jGdWYFemyuHI
Message-ID: <CAGq3pz4sbLxRz3AnQZehUpseDhGNY7Wi03Mce-w=Ex4uGy3x8w@mail.gmail.com>
Subject: Re: [GIT PULL linux-firmware.git] OLPC libertas firmware blobs
From: Daniel Drake <dsd@laptop.org>
To: Andres Salomon <dilinger@queued.net>
Cc: David Woodhouse <dwmw2@infradead.org>, cjb@laptop.org,
        linux-kernel@vger.kernel.org, dcbw@redhat.com,
        libertas-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 July 2011 06:50, Andres Salomon <dilinger@queued.net> wrote:
>  libertas/usb8388_v5.bin |  Bin 100292 -> 127824 bytes

It looks like you're replacing the generic Marvell v5 firmware with
the OLPC-forked version. Technically these are independent branches,
so it would make more sense to have the OLPC one separately e.g.
usb8388_olpc_v5.bin.

Daniel
