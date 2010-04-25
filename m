Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab0DYVYM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 17:24:12 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:33052 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab0DYVYK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 17:24:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=lgN1j5lFzuU5mlM+sXFNfJyDZIwSjtTggjn/RcDCMBVJC8y16TnBReFYI9b3Zd5Npf
         e9NlrLx6lIq2ieDyqmDEQK4qTcexOguM89C0F+r7V2RkXUWuWEUks9NXPJc6tbC01jpj
         mnQA4Pz9HaLe4WN53p2xM9k+cWZ//rOUiIBGo=
From: Pedro Francisco <pedrogfrancisco@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: ath5k misbehaving affecting other kernel parts unrelated?
Date: Sun, 25 Apr 2010 22:24:04 +0100
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: me@bobcopeland.com, Vegard Nossum <vegard.nossum@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       mickflemm@gmail.com
References: <201004230806.13628.pedrogfrancisco@gmail.com> <20100425192242.GA27921@hash.localnet> <4BD4A639.8000703@gmail.com>
In-Reply-To: <4BD4A639.8000703@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004252224.05509.pedrogfrancisco@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Domingo, 25 de Abril de 2010 21:29:45 Jiri Slaby escreveu:
> On 04/25/2010 09:22 PM, me@bobcopeland.com wrote:
> > On Sat, Apr 24, 2010 at 06:28:36PM +0100, Pedro Francisco wrote:
> >> ========================================================================
> >> ===== [ 2658.663424] BUG kmalloc-4096: Poison overwritten
> >> [ 2658.663483]
> > 
> > Ok there are 4 messages here, two of them are definitely 802.11 beacons,
> > which would point the finger squarely at ath5k.  We had reports of this
> > some time ago but a few things got rewritten around that time.  I'd guess
> > the rx DMA code is still subtly broken.
> > 
> >> 6b 6b kkkkkkkkkkkkkkkk
> >> [ 2658.664816]   Object 0xed3db0c0:  c4 00 84 00 00 22 43 89 42 69 4e 12
> >> ca 6f 6f 6f �...."C.BiN.�ooo
> >> [ 4689.945547]   Object 0xed3d9080:  c4 00 70 00 00 22 43 89 42 69 fe 08
> >> eb 14 14 14 �.p.."C.Bi�.�...
> > 
> > Offhand, I'm not sure what pattern these are.
> 
> These are CTS frames. So I think ath5k is to blame too :/.
> 
> regards,

Do note that's on a 2.6.32 kernel. I've however a new dmesg/syslog which on a 
2.6.34-rc5-daily has the same kind of issues. It's 400kB in size..... Do you 
want me to send it to the mailing list?

Or should I open a bug report on the kernel bugzilla and post them there? Or 
do both?

-- 
Pedro
