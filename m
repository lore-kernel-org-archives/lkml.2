Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab1KFNkl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 08:40:41 -0500
Received: from mail.anarazel.de ([217.115.131.40]:52485 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab1KFNkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 08:40:40 -0500
From: Andres Freund <andres@anarazel.de>
To: Gleb Natapov <gleb@redhat.com>
Subject: Re: 3.1: NULL pointer dereference after perf usage
Date: Sun, 6 Nov 2011 14:40:30 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-andres-dirty; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <201111060358.59430.andres@anarazel.de> <20111106091229.GB3225@redhat.com>
In-Reply-To: <20111106091229.GB3225@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111061440.31714.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday, November 06, 2011 10:12:29 AM Gleb Natapov wrote:
> On Sun, Nov 06, 2011 at 03:58:59AM +0100, Andres Freund wrote:
> > Somewhere in the 3.1 cycle - haven't yet bisected - I started to get
> > somewhat reprodcable crashes after using perf.
> > There is no direct correlation with a concrete action via perf I can
> > see so far but without having used perf the system runs stable.
> 
> Can you try those patches please?
> https://lkml.org/lkml/2011/10/23/163
> https://lkml.org/lkml/2011/10/18/390
After applying those the system runs smoothly - while using perf obviously - 
for over an hour.

Thanks,

Andres
