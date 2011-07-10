Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab1GJMbO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 08:31:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42899 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930Ab1GJMbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 08:31:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Subject: Re: [Bug #38102] BUG kmalloc-2048: Poison overwritten
Date: Sun, 10 Jul 2011 14:32:18 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <AtAvQwe5sAK.A.loH.OlYGOB@chimera> <gK_efVqs2fP.A.O5H.olYGOB@chimera> <CAB9v_DGfA4YLhDKeEZziFLgCak8cL+CjGdjkiwa_YtF_HHw5Dg@mail.gmail.com>
In-Reply-To: <CAB9v_DGfA4YLhDKeEZziFLgCak8cL+CjGdjkiwa_YtF_HHw5Dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107101432.18589.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 10, 2011, Alexey Zaytsev wrote:
> On Sun, Jul 10, 2011 at 14:58, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.38 and 2.6.39.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.38 and 2.6.39.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> 
> Hey.
> 
> This is not a regression, it's been this way since at least since
> 2.6.27 (checked), and probably from the beginning.

Thanks, dropping from the list.

Rafael
