Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab0H1XSx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 19:18:53 -0400
Received: from n2-vm0.bullet.mail.gq1.yahoo.com ([67.195.23.154]:21255 "HELO
	n2-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751918Ab0H1XSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 19:18:52 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 599115.42842.bm@omp132.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=gKosm3pgG71M2D0PRnTtPw1PQhiEkfzmvRhuOwRbrgapU41ZGG7rH9+MRp6SDX9dHD1G1Gny0m+hLTr8cPx/u4gIUaRFyglIqWCaNGAnlMiqdDHEWTCkTtsIzvLGe17ZZynPDDv7t6bPeR6xXARvOSMFFw3sGmVECc42nI3HRj0=;
Message-ID: <461057.78283.qm@web180310.mail.gq1.yahoo.com>
X-YMail-OSG: X_z40wUVM1mCHxTY2pMAUcS5khdPgjgHX85dFtmmA5vkPZR
 vg82VbefZvzy2MgUX6FagkHG.lGh8c0m.WvQ_nS_3Q2AOn9AGoV3K.qu0bl5
 jnNTdnN0iUNyUOha.Z1KBUmilkHqRj3YBWBJPSAuFSFvnf9s6BHXkgxfnv.5
 aewZaKTp.aKf.DkdT0pc7AObeAPViaYfYDY3E9bB0JeWuRsbxRHuE8O711zu
 JwycjyP1pV_oy4CsZ8tm.G7AZoyq42avrCZgePUA6dREA2k7SLkyRsz_8gMh
 u9L4m5PwFoAutxRwJewOHVcmpcQbNeCW.Q1rVo3f2ve0Y0ZD6EbQtTkrOem_
 4TEt8S1sfCYphgOk-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sat, 28 Aug 2010 16:18:51 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] GPIO: add support for NXP 74HC164 GPIO expander
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Miguel Gaio <miguel.gaio@efixo.com>, Juhos Gabor <juhosg@openwrt.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Florian Fainelli <florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Sat, 8/28/10, Florian Fainelli <florian@openwrt.org> wrote:

> This patch adds support for
> NXP's 74HC164 GPIO expander.

The 74164 parts are standard 74xxx series
discrete logic parts sold by many vendors
as 8 bit shift registers ... and in many
logic series (HC, HCT, more).

At least describe this as generic to all
those 8-bit shift registers, not just NXP.
And not as "GPIO expanders"; data sheets
describe them as shift registers.  Kconfig
can say that the shift registers are being
used for GPIO (output) expansion.

I suppose it's reasonable not to support the
way these chips can be daisy-chained, but it'd
be worth a comment, IMO; that strikes me as a
think someone will add at some point, via some
platform data (e.g.32 GPIO outputs from 4 chips).

- Dave

p.s. I'd have to pull out my data sheet collection
to verify, but it might be the 74163 which can
be used as an 8 bit parallel to serial (input)
 shift register...



