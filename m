Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab0L3NN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 08:13:59 -0500
Received: from inx.pm.waw.pl ([195.116.170.130]:48739 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab0L3NN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 08:13:58 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Ben Hutchings" <ben@decadent.org.uk>
Subject: Re: [Bug #25442] ixp4xx defines FREQ macro; conflicts with gspca/ov519 driver
References: <96DQe4a_2tH.A.4RE.497GNB@chimera>
	<sV7shrPOroO.A.CqE.K-7GNB@chimera>
Date: Thu, 30 Dec 2010 14:13:38 +0100
In-Reply-To: <sV7shrPOroO.A.CqE.K-7GNB@chimera> (Rafael J. Wysocki's message
	of "Thu, 30 Dec 2010 00:07:02 +0100 (CET)")
Message-ID: <m3zkrnv1x9.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> The following bug entry is on the current list of known regressions
> from 2.6.36.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=25442
> Subject		: ixp4xx defines FREQ macro; conflicts with gspca/ov519 driver

This FREQ has been there for years. Not that it makes it smart, and
I'll obviously send Ben's patch upstream for 2.6.38. Still processing
incoming mail queue :-(
-- 
Krzysztof Halasa
