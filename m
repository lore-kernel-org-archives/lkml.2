Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab1ILP1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 11:27:48 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:38527 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028Ab1ILP1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 11:27:46 -0400
From: James Cloos <cloos@jhcloos.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: found __[us]{8,16,32,64} type without #include <linux/types.h>
In-Reply-To: <201109091629.52879.arnd@arndb.de> (Arnd Bergmann's message of
	"Fri, 9 Sep 2011 16:29:52 +0200")
References: <m3vct1u75k.fsf@jhcloos.com> <201109091629.52879.arnd@arndb.de>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/24.0.50 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQAgMAAABinRfyAAAACVBMVEX///8ZGXBQKKnCrDQ3
 AAAAJElEQVQImWNgQAAXzwQg4SKASgAlXIEEiwsSIYBEcLaAtMEAADJnB+kKcKioAAAAAElFTkSu
 QmCC
Copyright: Copyright 2011 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Mon, 12 Sep 2011 11:27:03 -0400
Message-ID: <m3zki9wzkw.fsf@jhcloos.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "AB" == Arnd Bergmann <arnd@arndb.de> writes:

AB> The script only checks for direct inclusions of types.h, while the
AB> drm headers get it from drm.h.

I see.  It had been quite some time since I last did a make 1>/dev/null,
long enough that I hadn't noticed that message before.

It is good to know that it is a false positive.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
