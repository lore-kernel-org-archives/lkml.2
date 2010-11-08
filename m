Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab0KHLdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:33:09 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48851 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab0KHLdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:33:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QCd66YCXCWLC6mrQkUvQ+jlsRS38zNjvqFSVYZiWrKzuTJVO1SDfVKIufR76JREH2Q
         wT88mWYYElJJoEAFNDMbEvQAaQfgTsd22v6ulIiUPwirztH+7e/hvh1ZDTtS1kenB0Xd
         Le3Ijf/Mz/aJAsAwbYbhzjGkghGTqFr/tDUfI=
MIME-Version: 1.0
In-Reply-To: <1289213695.3916.396.camel@constitution.bos.jonmasters.org>
References: <1289211512.3916.383.camel@constitution.bos.jonmasters.org>
	<b9dded$h0q3am@orsmga002.jf.intel.com>
	<1289213695.3916.396.camel@constitution.bos.jonmasters.org>
Date: Mon, 8 Nov 2010 11:33:06 +0000
Message-ID: <AANLkTinOeu28+uJ=4KwKtn5CPZJyo=VuyhvuNUOgbe+L@mail.gmail.com>
Subject: Re: [bisected] offset display bug in i915
From: James Courtier-Dutton <james.dutton@gmail.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 November 2010 10:54, Jon Masters <jonathan@jonmasters.org> wrote:
>
> Here is the EDID output after booting:
>
> [jcm@monticello ~]$ hexdump /sys/class/drm/card0-LVDS-1/edid
> 0000000 ff00 ffff ffff 00ff 6422 03e9 8544 0001
> 0000010 141c 0301 1680 780d 860a 9426 5157 2790
> 0000020 4f21 0054 0000 0101 0101 0101 0101 0101
> 0000030 0101 0101 0101 1194 b000 5840 2019 2335
> 0000040 0045 81dc 0000 1900 1416 d800 5840 2026
> 0000050 235d 0415 81dc 0000 0000 0000 fe00 0000
> 0000060 0000 0000 0000 0000 0000 0000 0000 fe00
> 0000070 0000 0000 0000 0000 0100 0000 0000 f200
> 0000080
>
hexdump -C  is a little easier to read and compare with other hexdumps.
