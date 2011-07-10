Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab1GJLxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 07:53:21 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55010 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab1GJLxG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 07:53:06 -0400
MIME-Version: 1.0
In-Reply-To: <gK_efVqs2fP.A.Y3H.jlYGOB@chimera>
References: <AtAvQwe5sAK.A.loH.OlYGOB@chimera>
	<gK_efVqs2fP.A.Y3H.jlYGOB@chimera>
Date: Sun, 10 Jul 2011 14:53:05 +0300
X-Google-Sender-Auth: Sm_hUdCA_1Zv7cPp6pzUH_4IspE
Message-ID: <CAOJsxLEGqpcQP3S+TLBjpRsM=UTk=zyuHBoswXkVwbHsLaDqqg@mail.gmail.com>
Subject: Re: [Bug #38132] [Warning] 2.6.39.x latencytop
From: Pekka Enberg <penberg@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Watts <akwatts@ymail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
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
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=38132
> Subject         : [Warning] 2.6.39.x latencytop
> Submitter       : Andrew Watts <akwatts@ymail.com>
> Date            : 2011-06-14 17:07 (27 days old)
> Message-ID      : <80098.5633.qm@web111013.mail.gq1.yahoo.com>
> References      : http://marc.info/?l=linux-kernel&m=130807128506490&w=2

This is a WARN_ON added in commit 6752ab4a ("tracing: Deprecate
tracing_enabled for tracing_on") that lets the user know about
deprecated ABI. It's somewhat unfortunate that there's no mention in
the changelog if everyone agreed on the deprecation or not...

That said, assuming the deprecation is OK (hi Steven, Frederic, Ingo!)
I think this issue can be closed.

                        Pekka
