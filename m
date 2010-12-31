Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab0LaOIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 09:08:51 -0500
Received: from inx.pm.waw.pl ([195.116.170.130]:58450 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249Ab0LaOIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 09:08:50 -0500
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
	<m3zkrnv1x9.fsf@intrepid.localdomain> <201012301545.15667.rjw@sisk.pl>
Date: Fri, 31 Dec 2010 15:08:30 +0100
In-Reply-To: <201012301545.15667.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Thu, 30 Dec 2010 15:45:15 +0100")
Message-ID: <m339pe6nmp.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

>> This FREQ has been there for years. Not that it makes it smart, and
>> I'll obviously send Ben's patch upstream for 2.6.38. Still processing
>> incoming mail queue :-(
>
> Well, the patch is in the mainline, which is why it's still listed.

s/is/isn't/ I assume.

I was referring to the "regression" thing only, i.e. there is no any
regression here, AFAIK at least.
-- 
Krzysztof Halasa
