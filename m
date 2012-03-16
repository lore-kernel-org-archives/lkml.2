Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761738Ab2CPMSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 08:18:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56153 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761742Ab2CPMSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 08:18:12 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH v7 1/3] Documentation: common clk API
Date: Fri, 16 Mar 2012 12:18:05 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Mike Turquette <mturquette@ti.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org> <alpine.LFD.2.02.1203161129010.2466@ionos> <CAP245DXV5oE+-y+PQCcSM016h-J+UgTi1efmdrcyeQge4k1Cfw@mail.gmail.com>
In-Reply-To: <CAP245DXV5oE+-y+PQCcSM016h-J+UgTi1efmdrcyeQge4k1Cfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203161218.05125.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:BIRHa8zv5Xi7yaifH6XBg3aPn3U6T5N5ktt3sqQe304
 XTfgSWMX56q1MiawnbOF6KWiWJ5lRQJ09HxDgNsqd4F1Jyd/GQ
 c7fer+ik9GBO9ntrS9yXfPywOWlBHFJ1r5Bvi1dahAW1hTEeda
 b7EuFtx/V5l666dXIOTsu2QEz5RZpTL5JlKlmiCihriymCuEXQ
 rUizmJDmKDkbxl3j/upJNI3MWXhmkrMs2uTGBDzzOwOtorINfZ
 rTC4tAwUWi7AG2Gyf6Sv37mCXUO8fRQkpOvydwrn2r4el8j49w
 nskSRMOhkIwLAkuZSPGnCqr3+fc/1GFmJM+El5eN+mGphZ+z4e
 vrIuE3E6FJWKzsqmvNslHlcUqnl9FSeGUV1uNOPX3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 March 2012, Amit Kucheria wrote:
> On Fri, Mar 16, 2012 at 12:29 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Fri, 16 Mar 2012, Linus Walleij wrote:
> >
> >> On Fri, Mar 16, 2012 at 7:11 AM, Mike Turquette <mturquette@linaro.org> wrote:
> >>
> >> > Provide documentation for the common clk structures and APIs.  This code
> >> > can be found in drivers/clk/ and include/linux/clk*.h.
> >>
> >> Acked-by: Linus Wallej <linus.walleij@linaro.org>
> >> For this three-piece v7 patchset.
> >>
> >> It already does magnitudes more advanced stuff than what I need
> >> so I'm pretty pleased, any remaining details can surely be ironed out
> >> in-tree.
> >
> > Ack. We really need to get that in now and sort out the details in
> > tree otherwise we will never finish that thing.
> >
> 
> Thomas, Russell, Arnd,
> 
> Can we shoe-horn this thing into 3.4 (it is a bit late, i know) so
> that platform ports can gather speed? Several people are waiting for a
> somewhat stable version before starting their ports.
> 
> And what is the path into mainline - will Russell carry it or Arnd
> (with Russell's blessing)?

I would suggest putting it into a late/* branch of arm-soc so it finally
gets some linux-next exposure, and then sending it in the second week of the
merge window.

Russell, please let me know if you want to carry it instead or if you
have found any last-minute show stoppers in the code.

	Arnd
