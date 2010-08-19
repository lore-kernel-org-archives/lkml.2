Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab0HSQFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 12:05:05 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:4800 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308Ab0HSQFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 12:05:02 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o7JG4nPJ015195
Subject: Re: [RFC][PATCH] introduce ptr_diff()
From: Bernd Petrovitsch <bernd@sysprog.at>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1282233186.1713.10.camel@leonhard>
References: <1282217856-8625-1-git-send-email-namhyung@gmail.com>
	 <87aaoiu6z6.fsf@basil.nowhere.org>  <1282233186.1713.10.camel@leonhard>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 18:04:49 +0200
Message-ID: <1282233889.10440.220.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-DCC-dcc1-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fre, 2010-08-20 at 00:53 +0900, Namhyung Kim wrote:
> 2010-08-19 (목), 14:23 +0200, Andi Kleen:
> > IMHO it would be better to simply disable the warning in sparse instead
> > of uglying the code just to work around sparse bogosity. It doesnt' seem
> > to make much sense. A subtraction followed by a shift is not expensive.
[...]
> I'm curious who turns on that switch. -Wptr-subtraction-blows is turned
> off by default, I didn't use CF variable at build time and I could not
> find any reference of it in the source tree. Hmm..

sparse also gets gcc's parameters which include (usually) "-Wall". And
this activates it.
Adding -Wno-ptr-subtraction-blows to CHECKFLAGS should do the trick.

	Bernd
-- 
mobile: +43 664 4416156              http://www.sysprog.at/
    Linux Software Development, Consulting and Services

