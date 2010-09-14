Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab0INKbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 06:31:44 -0400
Received: from mx-1.vendo.no ([193.71.32.2]:59359 "EHLO mx-1.vendo.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab0INKbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 06:31:43 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Sep 2010 06:31:43 EDT
Message-ID: <4C8F4D7C.3090608@uw.no>
Date: Tue, 14 Sep 2010 12:25:00 +0200
From: "Daniel K." <dk@uw.no>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Lin Ming <lin@ming.vg>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Why not make LKML-Reference useful?
References: <AANLkTin9Ry6hCBciLkg2ExgERv9SHq5vO-Zvxy3Ei_JJ@mail.gmail.com>
In-Reply-To: <AANLkTin9Ry6hCBciLkg2ExgERv9SHq5vO-Zvxy3Ei_JJ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lin Ming wrote:
> What's LKML-Reference in the kernel git log?

The message id for the email sent to LKML.

> In my understanding, it's a link to the original discussion of the
> patch on LKML, for example
> 
> LKML-Reference: http://marc.info/?l=linux-kernel&m=128445596126705&w=2
> 
> But I never see such a link in the LKML-Reference of the git log.
> 
>     LKML-Reference: <201008300127.o7U1RC6Z044051@www262.sakura.ne.jp>
>     LKML-Reference: <20100913102541.20260.85700.stgit@ltc236.sdl.hitachi.co.jp>
>     LKML-Reference: <20100913121903.GB22238@darkstar>
> 
> Those LKML-Reference are really useless.
> 
> Why not put a link in LKML-Reference?

Domains come and go (marc.theaimsgroup.com => marc.info => ?), message
id's are forever.

Also, you should be able to look up the message on your favorite
LKML-archive website or search engine using the message id.


Daniel K.
