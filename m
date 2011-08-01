Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab1HAN04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 09:26:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45075 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab1HAN0t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 09:26:49 -0400
MIME-Version: 1.0
X-Originating-IP: [178.212.96.93]
Date: Mon, 1 Aug 2011 16:26:49 +0300
Message-ID: <CAFdoEiT54o+NQKO=dAcOXgyf6GJ1E51w_H_p7PJyRmynz8Sbzg@mail.gmail.com>
Subject: [Bug?] Machine hangs, rtl8192se possible cause
From: Jaroslaw Fedewicz <jafd@netstyle.com.ua>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Larry.Finger@lwfinger.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I own a Thinkpad Edge 13 (AMD, machine type 0197) laptop, which is
shipped with a Realtek 8192 SE WLAN card.

The WLAN support with this particular card was never brilliant under
Linux, first with (very) flakey drivers from Realtek which would stop
transmitting packets every so often or panic after a few hours of
usage. The in-tree drivers are better in this respect, but I'm
experiencing mysterious hangups every once in a while. The machine is
effectively dead and has to be power-cycled — no oops, no kernel
panic, no nothing, it just hangs and that's it.

I'm sure this is not a regression because the hangups were right there
from the start.

The last meaningful message which might be helpful was: "wait for
BIT(6) return value X" (I don't remember what X was, it was a while
ago and only once).

I don't know if there are other means to debug (netconsole over eth0?)
those hangs. The only other thing I know for sure that I can get a
week long uptime if I blacklist rtl8192se.ko from loading.

If I can provide any additional information to track the bug (or a
faulty piece of hardware?) down, please tell me. Google tells me
nobody reported this before, or it was just me feeding incorrect
keywords.

Thanks for your kind attention.

P. S. Tried netconsole before, got nothing to pinpoint the error. The
only recurring pattern I could see in it was that almost every time
the machine hanged was after ip6tables initialized, at least it was
the last message in the log.

P. P. S. I don't track netdev@ and linux-wireless@ lists, so please Cc: me.
