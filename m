Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0KCMf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 08:35:58 -0400
Received: from nm15-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.208]:33189 "HELO
	nm15-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754158Ab0KCMfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 08:35:55 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 497081.28094.bm@omp1041.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=C3NxTUXFsQO+6rB5+sHq6w9XX7ifa8rNB2RqaNAP7rpyysPcG6DR15KErZVr1MvyPBXGP+/2EKqLbR7H8HOe5W29uHuFC+ut9XXRy4MhZA9SeKhFXzUNsPpFS1uagtefFyCDaHRmZtlA36Rqe/s8652dFWO4oPBlvHIGSl84ROY=;
Message-ID: <129498.93810.qm@web180302.mail.gq1.yahoo.com>
X-YMail-OSG: H9GdJ7EVM1lNn8Byb31nfiNbLVN.ohYgdmIcAGeoVjsp3tW
 7vDtxViDyz4ENRPTjyL2H9L7MO9BkADtXDQ9PaaoJ3cOsGFHWjqjHOQvgwfF
 zIopp_WkxHmEkACQSTc3PvldLcij8NA3xRn7SV0KYb68dqcM_0SraXGEVVRL
 _aRWp5LabxepNZjBSDipH9yWEDgMhMmJytEbc8aO.qCquoR4HGqziQQAGCoo
 83h4UBJSayceNHqmNfFPsEeElShvRxc3EQ38gFIg_cFFYr5ucLVuApi96XdV
 1qwJ70yX8xJ5DEbRsiFkx4cV6ThzviD.bp0bM_mjHM_KJlTGKiUwT_TrB7lx
 llAcZ7zFcFAH8.ufRPT3_JoRyAyhTim3csAIj
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Wed, 3 Nov 2010 05:35:54 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v4 08/12] gpio: add ti-ssp gpio driver
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net, Cyril Chemparathy <cyril@ti.com>,
        spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, lrg@slimlogic.co.uk
In-Reply-To: <AANLkTin=3K0H+YdNM2Nhz63c3+Upp+rwApo-Ww4p5qH6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Wed, 11/3/10, Linus Walleij <linus.ml.walleij@gmail.com> wrote:
\
> Date: Wednesday, November 3, 2010, 3:18 AM
> 2010/11/3 David Brownell <david-b@pacbell.net>:
> 
> > That seems like
> > a better structure for various vendors' "SSP"
> > hardware (multifunction serial interface logic)
> 
> Incidentally the ARM PrimeCell PL022 is called SSP,
> "Synchronous Serial Port" and is not multifunction at all.

ISTR coming across that IP module; are you sure
that it only supports a single serial protocol,
instead of just a "small" variety" (multi)?
Unless the hardware only supports one protocol,
my point holds.

I wasn't implying that modules named SSP have
more in common than tending to support
more than a single serial protocol.  If they
only support one, they get names like"USART"
or sometimes CODEC.

- Dave

