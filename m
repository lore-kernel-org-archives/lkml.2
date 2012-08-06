Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab2HFX2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 19:28:34 -0400
Received: from zougloub.eu ([188.165.233.99]:38499 "EHLO zougloub.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757060Ab2HFX2b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 19:28:31 -0400
Date: Mon, 6 Aug 2012 19:29:30 -0400
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "H. PeterAnvin" <hpa@zytor.com>
Subject: Re: [Regression] "x86-64/efi: Use EFI to deal with platform wall
 clock" prevents my machine from booting
Message-ID: <20120806192930.77696520@zougloub.eu>
In-Reply-To: <501FE1ED0200007800092DF0@nat28.tlf.novell.com>
References: <20120805172903.5f8bb24c@zougloub.eu>
	<501EF3A2.20200@zytor.com>
	<501F83F20200007800092C1C@nat28.tlf.novell.com>
	<20120806125216.GA11863@srcf.ucam.org>
	<501FDDD30200007800092DDE@nat28.tlf.novell.com>
	<20120806091627.2ad5ed2e@zougloub.eu>
	<501FE1ED0200007800092DF0@nat28.tlf.novell.com>
Organization: none
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Aug 2012 14:25:33 +0100
"Jan Beulich" <JBeulich@suse.com> wrote:

> >>> On 06.08.12 at 15:16, JérômeCarretero <cJ-ko@zougloub.eu> wrote:
> > If it helps:
> > 
> > - I can bisect the patch further down (might be a bit silly because
> >   I don't quite understand it),
> > - you can suggest some modifications and at least I can test them
> 
> What would help most would be the full kernel log up to the crash,
> including the register and stack dumps that are presumably there.
> Without that there's nothing I can suggest.

There is absolutely no graphical output at this point (or I'd have provided
more info); I didn't look at the code yet, I'll see if I can do something, though.

-- 
cJ
