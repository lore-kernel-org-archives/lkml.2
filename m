Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab0LTHZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 02:25:10 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:53263 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab0LTHZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 02:25:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p7uOD22WFiP8SeTRV+xrSW+Hr8hSHPK+g6rNb8m11grc9RzsPyJfOUvoOjVYYNyR0r
         uid9X14YkrfHXCFLgmzGyysvd0CP2MG0xv9K3WLERFylVqT2XNfvTefpyjbyWW7BuOsA
         M9BoRQzZ+oWv6/5OJKinG/FKQhUCwDVDQaeJ4=
MIME-Version: 1.0
In-Reply-To: <xqq2Z3iR9HJ.A.9lH.p2fDNB@chimera>
References: <ZRNlsjykcOD.A.b-F.20fDNB@chimera>
	<xqq2Z3iR9HJ.A.9lH.p2fDNB@chimera>
Date: Sun, 19 Dec 2010 23:25:06 -0800
Message-ID: <AANLkTi=ApxE76PPOPjGPQCrO+YCwSQdCtpqAjUzYpiRa@mail.gmail.com>
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

On Sun, Dec 19, 2010 at 4:50 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
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
> Date            : 2010-09-28 22:30 (83 days old)
> Message-ID      : <<AANLkTim5WCGKPvEkOkO_YnMF9pg8mvLfQoFBNUFpfa_k@mail.gmail.com>>
> References      : http://marc.info/?l=linux-kernel&m=128571307018635&w=2
>
>
>

yep.. still here with the latest Mainline

-- 
Justin P. Mattock
