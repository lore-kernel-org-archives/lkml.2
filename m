Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab0INRnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:43:35 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:44240 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751499Ab0INRnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:43:35 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: pavGWWMVM1lY9T1b4l3Q0WSc81fHsIINFvGN0wcqxPNREYv
 UwKrW6450sE7CUUflASCqc4ajyckRfuGwMvknss3444ipNwzNFZSQ96V6N.I
 d5lXtOu7ZZ6SqA3a5ks4Pf6DE.RrF0Qn3_0eG4PYPaKcej0ZpQkIjrWqAf3N
 UnloGHlIwwkeeknq_V7j1xuAziosQ..h0c0hA1BP09q3KsDFQq04vwAXH3M6
 _KOEyPd1t1JDizOTRGYafc.TwF.s-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 14 Sep 2010 12:28:23 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
In-Reply-To: <AANLkTinxNbBQ3phKH8aoOSCO-+3FLn=te4OAqx4J8cU+@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1009141227430.31857@router.home>
References: <1284483964-2370-1-git-send-email-penberg@kernel.org> <1284483964-2370-2-git-send-email-penberg@kernel.org> <AANLkTinxNbBQ3phKH8aoOSCO-+3FLn=te4OAqx4J8cU+@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010, Pekka Enberg wrote:

> Unfortunately this breaks "slabtop". I guess we could try some other delimiter?

+ ?

