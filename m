Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387Ab0JRVhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 17:37:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58818 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155Ab0JRVhh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 17:37:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
Subject: Re: [Bug #20472] [2.6.35.5 -> .7] INFO: task rpcbind:14163 blocked for more than 120 seconds.
Date: Mon, 18 Oct 2010 23:36:51 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc8-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Trond Myklebust <trond.myklebust@fys.uio.no>
References: <TP5BfCZNRXD.A._8.uj1uMB@chimera> <7N-qxsaxKCN.A.TEB.0j1uMB@chimera> <201010181951.34620.pluto@agmk.net>
In-Reply-To: <201010181951.34620.pluto@agmk.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010182336.51265.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 18, 2010, Paweł Sikora wrote:
> On Sunday 17 October 2010 22:21:48 Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.35.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> 
> hi,
> 
> hot news from the front, recent tests on the pld-linux.org vendor kernel
> show that the random task blocking in 2.6.35.7 during medium/heavy load (~4..25)
> is related to the grsecurity patch. we'll forward problem report to the
> grsec maintainer asap...

So, to make things clear, this is not a mainline kernel issue, is it?

Rafael
