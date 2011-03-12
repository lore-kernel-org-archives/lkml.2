Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab1CLVGj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 16:06:39 -0500
Received: from inx.pm.waw.pl ([195.116.170.130]:40743 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998Ab1CLVGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 16:06:35 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Philippe LeCavalier <support@plecavalier.com>
Cc: Alejandro Riveira =?utf-8?Q?Fern=C3=A1ndez?= <ariveira@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESOLVED] Re: Second drive on VT6421
References: <1299350988-sup-2113@plc.intranet.plecavalier.com>
	<20110305210537.7675b600@varda>
	<1299355624-sup-9766@plc.intranet.plecavalier.com>
	<1299365533-sup-1295@plc.intranet.plecavalier.com>
Date: Sat, 12 Mar 2011 22:06:25 +0100
In-Reply-To: <1299365533-sup-1295@plc.intranet.plecavalier.com> (Philippe
	LeCavalier's message of "Sat, 05 Mar 2011 17:59:34 -0500")
Message-ID: <m3pqpw1226.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe LeCavalier <support@plecavalier.com> writes:

> There must be something about that chip...Perhaps the way the firmware
> allocates the bandwidth. ie 2 channels with a total of 3Gbps then a
> second drive cannot coexists if the first requests all 3Gbps?!

I think VT6421(A) is 1.5 Gb/s only.
To be honest, It was never able to get it to work reliably, esp. with
Transcend and/or Kingston SSDs.
-- 
Krzysztof Halasa
