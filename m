Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab2IMLLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 07:11:32 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36734 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab2IMLLa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 07:11:30 -0400
Message-ID: <5051BF56.7070506@arm.com>
Date: Thu, 13 Sep 2012 12:11:18 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>, David Brown <davidb@codeaurora.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Magnus Damm <magnus.damm@gmail.com>, Nicolas Pitre <nico@fluxnic.net>,
        Paul Mundt <lethal@linux-sh.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@linaro.org>, Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        "spear-devel@list.st.com" <spear-devel@list.st.com>
Subject: Re: [PATCH v9 00/13] Per sub-architecture SMP operations
References: <1347461906-13527-1-git-send-email-arnd@arndb.de>
In-Reply-To: <1347461906-13527-1-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.5a1pre
X-OriginalArrivalTime: 13 Sep 2012 11:11:19.0323 (UTC) FILETIME=[80146EB0:01CD91A0]
X-MC-Unique: 112091312112114301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/12 15:58, Arnd Bergmann wrote:
> As I promised at the ARM mini summit, I've updated Marc's series
> for smp operations according to my complaints. Unfortunately,
> I could not find version 7 of the patches when I started this,
> so I based my work on version 6 and had to redo the same
> changes.

I'm quite happy with that series. I don't have much to add (my SoB is
already all over the place), so if all platform maintainers are willing
to give their acks, let's merge the damned thing! :-)

	M.
-- 
Jazz is not dead. It just smells funny...

