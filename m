Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab0KKRN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:13:26 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47128 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab0KKRNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:13:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZH/CrBurTI81LACcOhsL8hjz/IFYFlZ9TUI+xrop+e3v4QsMwGEu2Ctw5QT95tfvsk
         ccBPYi5LLN7Bqy+1DzcLZHKCnlnM5S8xxvtfVfbVV+fWXrBw+xjfqRbrT1fuaHuTGwrk
         QvO+T3bITlzzyzEl0R0y9QLAmAW9ZZonlf6gg=
Subject: Re: [PATCH] [PERF] (Userspace Tools) Fix a compilation error with
 -fstack-protector and -Werror
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, Brian Gitonga Marete <marete@toshnix.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Cyrill Gorcunov <gorcunov@gmail.com>
In-Reply-To: <20101111170535.GA2203@ghostprotocols.net>
References: <AANLkTinHc7tMntW5NFAhu40RC7m2=HwbqOBeE-21vL8J@mail.gmail.com>
	 <20101018233834.GC5370@nowhere>
	 <AANLkTi=Ssz4WdMDXq-93GE9bPHoaQ8QyTSrWXDSCa7eH@mail.gmail.com>
	 <20101019064000.GC21782@elte.hu>
	 <AANLkTimqaTKu23HrgbffAht_Otn9L5k2oHMZDGki8MK+@mail.gmail.com>
	 <AANLkTin=0N0b=wK8974RGwXuTxpQ4BtH4bHwjsea+1tS@mail.gmail.com>
	 <20101019114904.GB25371@elte.hu> <20101019131152.GB3826@ghostprotocols.net>
	 <1289471135.17691.1026.camel@edumazet-laptop>
	 <20101111170535.GA2203@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 18:13:20 +0100
Message-ID: <1289495600.17691.1533.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 11 novembre 2010 à 12:05 -0500, Arnaldo Carvalho de Melo a
écrit :

> Ingo merged this while I'm away, its in tip/urgent.

So far so good ;)

Thanks !


