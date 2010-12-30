Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0L3AK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 19:10:57 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50012 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab0L3AK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 19:10:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UZkhZ9hbQsPqxQ0Wv7nbRgacvBATmfQuTmfyr+c4Z2VK2zb4dNSD/NtVHJwcGJZz6/
         BNUQS9gNCPPyNO/HOaeCFw73zL6sa8DW61TQ9+rOrV151FM9F08vIZhZ1aBq1tF/7maO
         qkicCw+IX+5K4AdKaK2Y+VH0gQ1a9n8TAK+hM=
MIME-Version: 1.0
In-Reply-To: <20101229160215.1a67d71a@jbarnes-desktop>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
	<20101229102127.06c0e505.randy.dunlap@oracle.com>
	<AANLkTims54zDXZYjZiiHfSOwy0W=gOF2jV8yopQxFBny@mail.gmail.com>
	<20101229121601.179983b7@jbarnes-desktop>
	<AANLkTikMMpdMr66n-VL9xdNVhmGMaWR74UdF5UB7cdCW@mail.gmail.com>
	<20101229131852.0792aac0@jbarnes-desktop>
	<20101229135315.5fe5c4e5@jbarnes-desktop>
	<AANLkTikk3Z_p+-uRB4iF8CUuMAyuKVtPbuht=hQOm2uH@mail.gmail.com>
	<20101229151323.4a675097@jbarnes-desktop>
	<AANLkTim=NTUtuAG=Gk=GeBHfTNM73xw6F8gjry6xsHs7@mail.gmail.com>
	<AANLkTim51EAwzUqSJGQ4LnJbbPNCqbhyJumUd=_WkB+T@mail.gmail.com>
	<20101229160215.1a67d71a@jbarnes-desktop>
Date: Thu, 30 Dec 2010 01:10:54 +0100
Message-ID: <AANLkTi=vPTQw-9O0UYKNvtMHZQq_feO6jbotUdrqpTQt@mail.gmail.com>
Subject: Re: Linux 2.6.37-rc8 (no fb)
From: Alex Riesen <raa.lkml@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Jeff Chua <jeff.chua.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 01:02, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> That's the easiest way; I think there are existing packages available
> as well, but you may have to check Karmic or newer.

Never mind. I'm lazy (that's not to say someone is too).

I redid the test:

Before running "xset dpms force standby":

 http://vin-soft.org/~raa/public/test/intel_reg_dumper-before

After running "sleep 3"

 http://vin-soft.org/~raa/public/test/intel_reg_dumper-suspend

After running "xset dpms force on; sleep 3"

 http://vin-soft.org/~raa/public/test/intel_reg_dumper-xset-on

After closing and opening the lid (displays backlight is back)

 http://vin-soft.org/~raa/public/test/intel_reg_dumper-lid
