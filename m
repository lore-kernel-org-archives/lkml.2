Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab1CHL51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 06:57:27 -0500
Received: from proxy.DResearch.DE ([87.193.137.100]:34121 "EHLO
	mail.dresearch.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754211Ab1CHL50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 06:57:26 -0500
Message-ID: <4D7619A2.4090207@dresearch.de>
Date: Tue, 08 Mar 2011 12:57:22 +0100
From: Steffen Sledz <sledz@dresearch.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Mario Schuknecht <m.schuknecht@dresearch.de>
Subject: Re: [PATCH v3] tcp: ioctl type SIOCOUTQNSD returns amount of data
 not sent
References: <20110304123950.2c91ebd9@lxorguk.ukuu.org.uk> <1299441595-18455-1-git-send-email-sledz@dresearch.de>
In-Reply-To: <1299441595-18455-1-git-send-email-sledz@dresearch.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Mar 2011 11:57:24.0439 (UTC) FILETIME=[FCF46670:01CBDD87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.03.2011 20:59, schrieb Steffen Sledz:
> From: Mario Schuknecht <m.schuknecht@dresearch.de>
> 
> In contrast to SIOCOUTQ which returns the amount of data sent
> but not yet acknowledged plus data not yet sent this patch only
> returns the data not sent.
> 
> For various methods of live streaming bitrate control it may
> be helpful to know how much data are in the tcp outqueue are
> not sent yet.
> 
> Signed-off-by: Mario Schuknecht <m.schuknecht@dresearch.de>
> Signed-off-by: Steffen Sledz <sledz@dresearch.de>
> ---
>  include/linux/sockios.h |    4 +++-
>  net/ipv4/tcp.c          |    9 +++++++++
>  2 files changed, 12 insertions(+), 1 deletions(-)

This is the patch version modified according to the comments from Alan Cox.

Anything else to do?

Steffen

-- 
DResearch Fahrzeugelektronik GmbH
Otto-Schmirgal-Str. 3, 10319 Berlin, Germany
Tel: +49 30 515932-237 mailto:sledz@DResearch.de
Fax: +49 30 515932-299
Geschäftsführer: Dr. Michael Weber, Werner Mögle;
Amtsgericht Berlin Charlottenburg; HRB 130120 B;
Ust.-IDNr. DE273952058

