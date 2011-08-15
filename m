Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab1HOVWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 17:22:21 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:60697 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751985Ab1HOVWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 17:22:19 -0400
X-Sasl-enc: 9rVTua0BZwWaq0v4lDV7hlGnOG92s5OLieGrAIpsfjMY 1313443339
Message-ID: <4E498E09.1000208@fastmail.fm>
Date: Mon, 15 Aug 2011 23:22:17 +0200
From: Bernd Schubert <bernd.schubert@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: 3.1-rc1-git9: Reported regressions 2.6.39 -> 3.0
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
In-Reply-To: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2011 09:02 PM, Rafael J. Wysocki wrote:

> Please let the tracking team know if there are any Bugzilla entries that
> should be added to the list in there.
> 

Could you please add

Bug-Entry       : https://bugzilla.kernel.org/show_bug.cgi?id=41212
Subject         : ipoib causes kernel panic (NULL pointer dereference)
Submitter       : Bernd Schubert <bernd.schubert@fastmail.fm>
Date            : 2011-08-15 15:40
Patch           : https://bugzilla.kernel.org/attachment.cgi?id=68942


Thanks,
Bernd
