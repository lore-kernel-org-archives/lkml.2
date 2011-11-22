Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab1KVPHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:07:37 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:27260 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757237Ab1KVPHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:07:32 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: j1VT8mgVM1m3x94C1b9ZYv37km6Gl2zWhDxJDKT0dX3eneH
 JCJ4EWOW9Qt4QZhrSIYyxupEFTXRqC9ATwMVPbNh4fMOZG9TcMkeC8pri8Ca
 ohb9Uo5KwOWc9XFy_jhpXGXrP7g65y0CCnpj1DfEeMycFp8ySOs9u1AO1Bdt
 Uij.LgikdhQqLL8vMShtbpNUdbLNnNTkZUARoQ7OISE9lNTbtqBhjI5FpHz8
 gdury5xjL2Rq2WwwuC6HM8Tn6liUcSfwh1MaFFB88i8PkMThTaT5uz8MdKv6
 Al2iE1nbp3tDwy2UVdVjACOgf9y2MWccu8q3HGNwS8WAoHbrYQyjz8zwy.3s
 PdlXc_X_Dz5_7e4d.HdeXr8rwFg8aAGI.0iNWa_Va9ur4NQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 Nov 2011 09:07:27 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Christian Kujau <lists@nerdbynature.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
In-Reply-To: <alpine.DEB.2.00.1111220900330.25785@router.home>
Message-ID: <alpine.DEB.2.00.1111220907050.25785@router.home>
References: <20111121161036.GA1679@x4.trippels.de>   <1321894353.10470.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>   <1321895706.10470.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>   <20111121173556.GA1673@x4.trippels.de>   <1321900743.10470.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
  <20111121185215.GA1673@x4.trippels.de>   <20111121195113.GA1678@x4.trippels.de> <1321907275.13860.12.camel@pasglop>   <alpine.DEB.2.01.1111211617220.8000@trent.utfs.org>   <alpine.DEB.2.00.1111212105330.19606@router.home>   <20111122084513.GA1688@x4.trippels.de>
  <1321954729.2474.4.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <1321955185.2474.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <alpine.DEB.2.00.1111220844400.25785@router.home> <1321973567.2474.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <alpine.DEB.2.00.1111220900330.25785@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.00.1111220907052.25785@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Christoph Lameter wrote:

> Not sure what the solution is but the simplest would be to disable
> validation if lockless is active.

That is already being done so you must have run the validation with
debugging on.

