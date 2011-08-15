Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab1HOKfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 06:35:46 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:49840 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab1HOKfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 06:35:42 -0400
MIME-Version: 1.0
In-Reply-To: <bkwpSnItbJM.A.tc.-MCSOB@chimera>
References: <xuTC4jRtHbB.A.l4H.gMCSOB@chimera>
	<bkwpSnItbJM.A.tc.-MCSOB@chimera>
Date: Mon, 15 Aug 2011 13:35:39 +0300
X-Google-Sender-Auth: m4kCmX7vwbAPanwyGGwzlAuRnT0
Message-ID: <CAOJsxLH3McBv+83rbd9aCfu_OULx=68KWfKwEGoNL5ygK2iM8Q@mail.gmail.com>
Subject: Re: [Bug #39922] WIFI becomes EXTREMELY slow ( ath9k ) making the
 connection unusable
From: Pekka Enberg <penberg@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Lukasz Olszewski <lcpak@epoczta.pl>, lrodriguez@atheros.com,
        jmalinen@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 10:07 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.39 and 3.0.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.39 and 3.0.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=39922
> Subject         : WIFI becomes EXTREMELY slow ( ath9k ) making the connection unusable
> Submitter       : Lukasz Olszewski <lcpak@epoczta.pl>
> Date            : 2011-07-24 09:20 (22 days old)

There's no evidence in the bug report that the ath9k maintainers know
about this. I'm CC'ing Luis and Jouni.
