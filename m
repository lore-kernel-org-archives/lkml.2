Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab0LQXIC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 18:08:02 -0500
Received: from nm9.bullet.mail.ne1.yahoo.com ([98.138.90.72]:20223 "HELO
	nm9.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753919Ab0LQXH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 18:07:59 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 266311.36986.bm@omp1020.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=AMxIBfc4cZhkN73pwt0U5+vBACMJNCMHsfIYmaU5MmD5Xxyp6oTtIqxeI9xfx60NgjFB5PAGycot6bDoQgIdG6qRrBsV6dWzP/3b+Kz9brtZp72QjJv/jiLAAkorYzdY+5aVF6rq7FK5FUhkwGv1pNfyA6tbqb6p7KgwQ0ewT+c=;
Message-ID: <288637.75833.qm@web180307.mail.gq1.yahoo.com>
X-YMail-OSG: J3OtCZUVM1n2y8E2.lSBrI30IbUYfRvxG153G9wtovE2Cgc
 4o1AwYmRP48g1N9UgGLXAlz7TvLI2LZLA35kAfxdYSv2FeoBQJCOveGu3P5q
 FmARmLTzml5.BA2kXXhkUO228sEgNHTvENBAIE4QbiDBAGyHt2JTpMDX1of9
 0QDZcoYaWpJZUBxOMjW0V0OAOQM07AOh1z6CYQleHTAoMyXPHbdLT.t9CVLf
 cwJM1YFiaPRzX5PatvLjEFwjSkU2wHMQdBcxQjk4vop.fkEG6Zn1mqd7L.dS
 JaYsbcO8ah4qGoskHMs4grLRtxRlLaRMovDnLs1OXA9Cjgx1GKt8hU_en0fZ
 shvRHey5ti2N7lX2F4se3BAPnPiNKi8TyGW5COrl32rnbj0ztps6wk0aOOOC
 eAK2kBsviVX7lEAP8
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Fri, 17 Dec 2010 15:07:57 -0800 (PST)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [RFC] Align tegra-ehci DMA transfers to 32B
To: Greg KH <gregkh@suse.de>, rmorell@nvidia.com
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Benoit Goby <benoit@android.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>,
        Olof Johansson <olof@lixom.net>, Erik Gilling <konkers@android.com>,
        Colin Cross <ccross@android.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101217224429.GF25105@morell.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Odd.  This is a functional regression with respect
to previous NVidia EHCI IP; the stuff in your PCI
south bridges behaves normally, as I recall; no
such  alignment restrictions.

