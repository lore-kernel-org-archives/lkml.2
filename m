Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab1GJMHE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 08:07:04 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37412 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab1GJMG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 08:06:59 -0400
MIME-Version: 1.0
In-Reply-To: <gK_efVqs2fP.A.k7.hnYGOB@chimera>
References: <AtAvQwe5sAK.A.loH.OlYGOB@chimera>
	<gK_efVqs2fP.A.k7.hnYGOB@chimera>
Date: Sun, 10 Jul 2011 15:06:57 +0300
X-Google-Sender-Auth: BQ9fr7XAyj5gL4_9TwFDBB7cvIs
Message-ID: <CAOJsxLE9UBoMocTaWAt7DSoFFwGP5oD901XyeK6jGHEzUuSjDg@mail.gmail.com>
Subject: Re: [Bug #34942] [Bug] Kdump does not work when panic triggered due
 to MCE
From: Pekka Enberg <penberg@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "K.Prasad" <prasad@linux.vnet.ibm.com>, borislav.petkov@amd.com,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 1:58 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.38 and 2.6.39.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.38 and 2.6.39.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=34942
> Subject         : [Bug] Kdump does not work when panic triggered due to MCE
> Submitter       : K.Prasad <prasad@linux.vnet.ibm.com>
> Date            : 2011-05-06 16:54 (66 days old)
> Message-ID      : <20110506165412.GB2719@in.ibm.com>
> References      : http://marc.info/?l=linux-kernel&m=130470087226270&w=2

There's actually no mention that kdump worked with MCE in 2.6.38
either. So is this really a regression?

                        Pekka
