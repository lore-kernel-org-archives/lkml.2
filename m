Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1ABTUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 14:20:20 -0500
Received: from inx.pm.waw.pl ([195.116.170.130]:46714 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab1ABTUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 14:20:19 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #25442] ixp4xx defines FREQ macro; conflicts with gspca/ov519 driver
References: <96DQe4a_2tH.A.4RE.497GNB@chimera>
	<sV7shrPOroO.A.CqE.K-7GNB@chimera>
	<m3zkrnv1x9.fsf@intrepid.localdomain> <201012301545.15667.rjw@sisk.pl>
	<m339pe6nmp.fsf@intrepid.localdomain>
	<1293806447.2870.36.camel@localhost>
Date: Sun, 02 Jan 2011 20:19:55 +0100
In-Reply-To: <1293806447.2870.36.camel@localhost> (Ben Hutchings's message of
	"Fri, 31 Dec 2010 14:40:47 +0000")
Message-ID: <m3d3ofun8k.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <ben@decadent.org.uk> writes:

> There is a regression for the ov519 driver on ixp4xx.

Right. It seems I was reading what wasn't written.
-- 
Krzysztof Halasa
