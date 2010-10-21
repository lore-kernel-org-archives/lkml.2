Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab0JUKAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:00:55 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49910 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab0JUKAy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:00:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IH9CwV9TsL76UxoLrTTnitU7x8T5w3+AAzmeKPVlK5V1uZHVVigCFzpgvk4ySkvHTN
         cV0nv6cuSSvms9+0pWppb1R0yQGusjAQ0GdmtOxvGADZD7Vyh0N0OoghmFJsgEwLemGF
         L8dSsl66wHQ0mHfnJVVuSCLS0MG+wymjG+O+k=
MIME-Version: 1.0
In-Reply-To: <AANLkTikjByC1_BQvPv=Stkdph1cV=a8CwcqrcBv6u0+p@mail.gmail.com>
References: <AANLkTim+vj_OAd22TdThuC-HSqUiDjguOHQWjyqFaq6N@mail.gmail.com>
	<AANLkTi=Cpq2_vV2RGcoQhrqk8xpL59AvLFPzfvTBk5Xa@mail.gmail.com>
	<4CBF8BDB.7090907@gmail.com>
	<20101021075401.GC22100@n2100.arm.linux.org.uk>
	<AANLkTikjByC1_BQvPv=Stkdph1cV=a8CwcqrcBv6u0+p@mail.gmail.com>
Date: Thu, 21 Oct 2010 12:00:53 +0200
Message-ID: <AANLkTik=27zjJacQTQhd6E4rGuERg19rAd5cgnLTDEoR@mail.gmail.com>
Subject: Re: [RFC] Removal of dead code from arch/arm/*
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Eric Miao <eric.y.miao@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/21 Zimny Lech <napohybelskurwysynom2010@gmail.com>:
> I tried to cross compile allyesconfig to test my changes and I hit this
>  CC      drivers/gpio/janz-ttl.o
> drivers/gpio/janz-ttl.c: In function ‘ttl_set_value’:
> drivers/gpio/janz-ttl.c:107: error: implicit declaration of function
> ‘iowrite16be’

Another build error not caused by my patch AFAICS

  CC      drivers/input/touchscreen/eeti_ts.o
drivers/input/touchscreen/eeti_ts.c: In function ‘eeti_ts_irq_active’:
drivers/input/touchscreen/eeti_ts.c:65: error: implicit declaration of
function ‘irq_to_gpio’


-- 
Slawa!
N.P.S.

Les fleurs du mal unfold
Comme les fleurs du mal
Dark demons of my soul
Un amour fatal
