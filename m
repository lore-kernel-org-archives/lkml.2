Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab0HQE4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 00:56:30 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51223 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab0HQE43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 00:56:29 -0400
Date: Tue, 17 Aug 2010 06:58:20 +0200
From: Borislav Petkov <bp@amd64.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        David Miller <davem@davemloft.net>, Borislav Petkov <bp@amd64.org>
Subject: Re: [RFC PATCH 0/0 v3] callchain fixes and cleanups
Message-ID: <20100817045820.GA676@aftab>
References: <1281991715-10367-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281991715-10367-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, Aug 16, 2010 at 04:48:29PM -0400

Hey Frederic,

> Built-tested on PowerPc, Arm and SuperH (can someone point me to a
> ready to use sparc cross compiler, like those that can be found there
> for other archs: http://www.codesourcery.com/sgpp/lite_edition.html ?)

Have you by chance tried http://www.kernel.org/pub/tools/crosstool/
already?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
