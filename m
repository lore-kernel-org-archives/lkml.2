Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab0KIJjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:39:51 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:41946 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab0KIJjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:39:48 -0500
Date: Tue, 9 Nov 2010 18:39:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Alexey Charkov <alchark@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6 v4] ARM: Add support for the display controllers in VT8500 and WM8505
Message-ID: <20101109093925.GA21814@linux-sh.org>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com> <1289147348-31969-6-git-send-email-alchark@gmail.com> <20101108041721.GA11605@linux-sh.org> <20101108141407.GA25739@alchark-u3s.lan> <20101108204315.GA12050@linux-sh.org> <AANLkTikXffMT9ZiUpm2QAoW+KPJN3MBf55Dgruj1EJN0@mail.gmail.com> <20101108213008.GB17708@linux-sh.org> <20101108234239.GA20819@alchark-u3s.lan> <20101108235407.GB18385@linux-sh.org> <AANLkTim047K-RjLLcz3124Wm+-he8s5AirAsD6R_kitN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim047K-RjLLcz3124Wm+-he8s5AirAsD6R_kitN@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 03:03:01AM +0300, Alexey Charkov wrote:
> Is there anybody I should address specifically to get this merged?
> 
I've set up an fbdev tree now, so I'll just take this through there. It
looks like the ordering shouldn't be important, so this can be applied
independent of the rest, and it simply won't show up until the other bits
have settled in .38.
