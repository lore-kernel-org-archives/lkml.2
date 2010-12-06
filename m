Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab0LFGd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 01:33:29 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53371 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab0LFGd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 01:33:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rQJiXiwv2qSi8YZMn/WcUhCEGjkor4zyC9hFWSPxpF3whjoOGACS3vTXs0I2Xu3AkQ
         j34q2baYR52V4JxnUdwLu+03QKnO6T0T/SmieEq6AQ9WAN8y+x4xsXM9fOiIz7i1Vtm1
         z2MoKPPA8EKPM2XWo/RwGiaV0eRzwi/FzifQY=
MIME-Version: 1.0
In-Reply-To: <z3LGq_ncuOB.A.huF.kB_-MB@chimera>
References: <jyQ21do2hOF.A.qwD.m_--MB@chimera>
	<z3LGq_ncuOB.A.huF.kB_-MB@chimera>
Date: Sun, 5 Dec 2010 22:33:26 -0800
Message-ID: <AANLkTinFKcs+SzEfviPxm893k-vuzbXAh57XN_oOm7q9@mail.gmail.com>
Subject: Re: [Bug #19392] WARNING: at drivers/net/wireless/ath/ath5k/base.c:3475
 ath5k_bss_info_changed+0x44/0x168 [ath5k]()
From: Justin Mattock <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 5, 2010 at 12:34 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.35 and 2.6.36.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.35 and 2.6.36.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=19392
> Subject         : WARNING: at drivers/net/wireless/ath/ath5k/base.c:3475 ath5k_bss_info_changed+0x44/0x168 [ath5k]()
> Submitter       : Justin Mattock <justinmattock@gmail.com>
> Date            : 2010-09-28 22:30 (69 days old)
> Message-ID      : <<AANLkTim5WCGKPvEkOkO_YnMF9pg8mvLfQoFBNUFpfa_k@mail.gmail.com>>
> References      : http://marc.info/?l=linux-kernel&m=128571307018635&w=2
>
>
>

still here with the latest Mainline..

-- 
Justin P. Mattock
