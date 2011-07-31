Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab1GaM7m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 08:59:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37981 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab1GaM7k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 08:59:40 -0400
MIME-Version: 1.0
In-Reply-To: <20110731000521.45e48638@debxo>
References: <20110731000300.5c08e95f@debxo>
	<20110731000521.45e48638@debxo>
Date: Sun, 31 Jul 2011 13:59:38 +0100
X-Google-Sender-Auth: 6H3saeVTgxYY40Ks_fUir8kBzCs
Message-ID: <CAGq3pz75qVMuR_Hh3GKg8xK7T+_ZAW5gBZns6D6PfDYh4CF5GA@mail.gmail.com>
Subject: Re: [PATCH] libertas: prioritize usb8388_v5.bin firmware on OLPC machines
From: Daniel Drake <dsd@laptop.org>
To: Andres Salomon <dilinger@queued.net>
Cc: dcbw@redhat.com, David Woodhouse <dwmw2@infradead.org>,
        libertas-dev@lists.infradead.org, cjb@laptop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 July 2011 08:05, Andres Salomon <dilinger@queued.net> wrote:
> Note: I've not tested this out yet on an XO-1.  I'll do that after some
> feedback regarding the matching linux-firmware pull request.  This
> should address dsd's concern about changing the loading order of the
> firmware.

That indeed was a concern, but only until Dan Williams and Chris
pointed out that OLPC is the only usb8388 user. With that in mind, I
am in agreement with them that simply putting usb8388_olpc_v5.bin (or
whatever name is chosen) at the top of the firmware loading list is
the best option.

Daniel
