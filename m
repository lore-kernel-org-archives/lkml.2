Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab1GJL3Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 07:29:25 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46261 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab1GJL3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 07:29:22 -0400
MIME-Version: 1.0
In-Reply-To: <gK_efVqs2fP.A.O5H.olYGOB@chimera>
References: <AtAvQwe5sAK.A.loH.OlYGOB@chimera>
	<gK_efVqs2fP.A.O5H.olYGOB@chimera>
Date: Sun, 10 Jul 2011 15:29:21 +0400
Message-ID: <CAB9v_DGfA4YLhDKeEZziFLgCak8cL+CjGdjkiwa_YtF_HHw5Dg@mail.gmail.com>
Subject: Re: [Bug #38102] BUG kmalloc-2048: Poison overwritten
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 14:58, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.38 and 2.6.39.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.38 and 2.6.39.  Please verify if it still should
> be listed and let the tracking team know (either way).

Hey.

This is not a regression, it's been this way since at least since
2.6.27 (checked), and probably from the beginning.

>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=38102
> Subject         : BUG kmalloc-2048: Poison overwritten
> Submitter       : Alexey Zaytsev <alexey.zaytsev@gmail.com>
> Date            : 2011-06-23 17:33 (18 days old)
>
>
>
