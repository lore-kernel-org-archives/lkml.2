Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab0JHGF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 02:05:28 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40355 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab0JHGF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 02:05:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=kU2MBBu9XxByoahAxo4M24n0VRPrph4jCtRL1lTafd8n1w4S9FfipCDPAW2B+mFFk+
         jDrYu0NVUB0hd5MMFRa2Jy5L3F0ff4gNB0cgKi9b8AUbDba9M4vOr05/FoZYUSrDr4oZ
         TOKkhmBxDQulU26K5u4HDgy2EMqTcR3l6dl1E=
MIME-Version: 1.0
In-Reply-To: <6lwrd5r5bkngwsfbw998jv3h.1286513980329@email.android.com>
References: <6lwrd5r5bkngwsfbw998jv3h.1286513980329@email.android.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 8 Oct 2010 02:05:05 -0400
X-Google-Sender-Auth: equTSPm7S6y5kZFVe4fSUv8zXKg
Message-ID: <AANLkTin-eNQ9HSpfShGk8tC6e5AEv-dZXH_BPY6JUE0Y@mail.gmail.com>
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Ben Dooks <ben-linux@fluff.org>, Alan Cox <alan@linux.intel.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Feng Tang <feng.tang@intel.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 8, 2010 at 00:59, Daniel Walker wrote:
> I'm not disputing the serial core part. I ok with converting it to tty.

sorry, i missed the distinction you were making with the "disputation" qualifier

please dont top post
-mike
