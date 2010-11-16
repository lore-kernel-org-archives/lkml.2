Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab0KPTnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:43:05 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47843 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab0KPTnC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:43:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=GK8/eqF92i3pO5o51oyu4Gb1Z6CEnrueUCp4I8+Tx1EDvADHz0dwofnY5qKKq7oJX5
         DEY1yWuxY24LLqHqayV5TDTl859EcyQO/xRCpVZD3GcXretM5eVid3aHpim9H0hTGx3L
         mdwSAyx+VJ/IvFlsBPaE2+8cky02vc5XbbhlY=
From: Diego Calleja <diegocg@gmail.com>
Reply-To: diegocg@gmail.com
To: Dhaval Giani <dhaval.giani@gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Date: Tue, 16 Nov 2010 20:42:46 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2; KDE/4.5.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
References: <1289820766.16406.45.camel@maggy.simson.net> <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com> <AANLkTikjQKmo0j5xbvPiS=eriAUUZPMGKkcxt8w_z8XB@mail.gmail.com>
In-Reply-To: <AANLkTikjQKmo0j5xbvPiS=eriAUUZPMGKkcxt8w_z8XB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011162042.46232.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Martes, 16 de Noviembre de 2010 20:27:27 Dhaval Giani escribió:
> So what do you think about something like systemd handling it. systemd
> already does a lot of this stuff already in the form of process
> tracking, so it is quite trivial to do this. And more happily avoids
> all this complexity in the kernel.

Note that even if this was a mistake, systemd can disable it and use its
own heuristics. It would be nice to know what Lennart thinks about that,
because it would be pointless to have a feature that eventually could
be disabled in each boot in most distros.
