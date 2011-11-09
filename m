Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab1KIWcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 17:32:52 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58870 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab1KIWcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 17:32:50 -0500
MIME-Version: 1.0
In-Reply-To: <20111109201337.GH18207@ghostprotocols.net>
References: <20111108093225.GB32533@elte.hu>
	<EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu>
	<20111108125609.GA14272@ghostprotocols.net>
	<4EB9315A.10806@redhat.com>
	<20111108143228.GC14272@ghostprotocols.net>
	<4EB94D08.3010207@redhat.com>
	<20111109085120.GD11473@elte.hu>
	<4EBA5881.7080409@redhat.com>
	<20111109115502.GA18207@ghostprotocols.net>
	<20111109192509.GA22581@psychosis.jim.sh>
	<20111109201337.GH18207@ghostprotocols.net>
Date: Thu, 10 Nov 2011 00:32:49 +0200
Message-ID: <CAJL_dMv-7Kszo1tT-HzwjeqyifBfQEy5J+pjXrnfS3o0dm8UQQ@mail.gmail.com>
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git repository,
 tools/perf/ and tools/kvm/
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jim Paris <jim@jtan.com>, Gerd Hoffmann <kraxel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Theodore Tso <tytso@mit.edu>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"I'd even argue that that C library is obviously something the
kernelshould offer as well - so klibc is the way to go and would help
usfurther streamline this and keep Linux quality high."

I think there is code to share. Why not ?
