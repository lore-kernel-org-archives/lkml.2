Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab0EQQPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:15:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51841 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab0EQQPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:15:43 -0400
Message-ID: <4BF16BA6.3040404@biereigel-wb.de>
Date: Mon, 17 May 2010 18:15:34 +0200
From: Stefan Biereigel <security@biereigel-wb.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Donald Allen <donaldcallen@gmail.com>
CC: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: tickless scheduling
References: <AANLkTin6D2GP0yJJbPYGH1AcAM9-g219rAxSyW_ZlrXV@mail.gmail.com>	 <AANLkTikjgoBQWqvNxncMUFqWOEXtq4ePvGkvF-m0sGUE@mail.gmail.com>	 <AANLkTimnlZYonxKzfGHZTV8vwaDptOPHEPBjNhwnV55Y@mail.gmail.com>	 <1273540344.3843.101.camel@localhost.localdomain>	 <AANLkTilg2cn3lAIOruz6oZE7V-9uAFDORlbvTX3qxmwF@mail.gmail.com>	 <AANLkTilb_CGBolyv5Ps9VuhNxFZKtjck4om4G21ICaif@mail.gmail.com>	 <1273697523.2856.3.camel@localhost.localdomain>	 <AANLkTinBPDY_WVGaq2LUuOzH0niRpgJ4LEpXWkwBxVqh@mail.gmail.com>	 <4BF019CF.1030309@biereigel-wb.de> <AANLkTinDvxfub_CBYQru7yi9KAAjjf5Q4emme0VXSErG@mail.gmail.com>
In-Reply-To: <AANLkTinDvxfub_CBYQru7yi9KAAjjf5Q4emme0VXSErG@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/DJjzlv4PltNwragkl1eiAl+wUWK3Q69pw4RP
 5Ac0tzySyw1LO4DBMPQh1ybiiUK6uAsyPC54enF94octWC2MJl
 iyoW8Q85SMLUWUwIPq63E3vnqM+m7KcOGCPhqCazVw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.05.2010 17:26, schrieb Donald Allen:
> Stefan --
>
> Would you check the BIOS on your machine and report the maker and
> version number? If you've followed this, I'm especially interested to
> know if it's a Phoenix BIOS.
>
> Thanks --
> /Don
Hello Don,

I did try some things here. pci=nomsi didn't work really, but I think it
decreased the rate of stucks, even though I'm not sure. My BIOS is a
Phoenix TrustedCore with version number PG2G3A08, should be from 7/2009
or so.

I will try my next boot with hpet=disable and report my results. Thanks
for your help!
Stefan DK3SB
