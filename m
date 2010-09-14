Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab0INKrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 06:47:20 -0400
Received: from bar.sig21.net ([80.81.252.164]:40455 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab0INKrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 06:47:19 -0400
Date: Tue, 14 Sep 2010 12:47:12 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Lin Ming <lin@ming.vg>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Why not make LKML-Reference useful?
Message-ID: <20100914104712.GA17182@sig21.net>
References: <AANLkTin9Ry6hCBciLkg2ExgERv9SHq5vO-Zvxy3Ei_JJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin9Ry6hCBciLkg2ExgERv9SHq5vO-Zvxy3Ei_JJ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.8 (---)
X-Spam-21-Report: No, score=-3.8 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.586,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 05:52:26PM +0800, Lin Ming wrote:
> What's LKML-Reference in the kernel git log?
> In my understanding, it's a link to the original discussion of the
> patch on LKML, for example
> 
> LKML-Reference: http://marc.info/?l=linux-kernel&m=128445596126705&w=2
> 
> But I never see such a link in the LKML-Reference of the git log.
> 
> $cd linux-2.6
> $git log | grep LKML-Reference
> 
>     LKML-Reference: <201008300127.o7U1RC6Z044051@www262.sakura.ne.jp>
>     LKML-Reference: <20100913102541.20260.85700.stgit@ltc236.sdl.hitachi.co.jp>
>     LKML-Reference: <20100913121903.GB22238@darkstar>
> ......
> 
> Those LKML-Reference are really useless.
> 
> Why not put a link in LKML-Reference?

Marc and Gmane allow search by Message-ID:

e.g.

>     LKML-Reference: <20100913121903.GB22238@darkstar>

http://marc.info/?i=20100913121903.GB22238@darkstar
http://mid.gmane.org/20100913121903.GB22238@darkstar


HTH,
Johannes
