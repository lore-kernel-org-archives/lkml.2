Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab1KIKuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 05:50:19 -0500
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:60613 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754019Ab1KIKuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 05:50:17 -0500
To: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel  =?UTF-8?Q?Git=09repository=2C=20tools/perf/=20and=20tools/kvm/?=
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Wed, 09 Nov 2011 11:50:15 +0100
From: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Theodore Tso <tytso@mit.edu>, Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4EBA5881.7080409@redhat.com>
References: <20111107203255.GF24234@thunk.org>
 <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com>
 <4EB85969.2010108@codemonkey.ws>
 <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu>
 <20111108093225.GB32533@elte.hu>
 <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu>
 <20111108125609.GA14272@ghostprotocols.net> <4EB9315A.10806@redhat.com>
 <20111108143228.GC14272@ghostprotocols.net> <4EB94D08.3010207@redhat.com>
 <20111109085120.GD11473@elte.hu> <4EBA5881.7080409@redhat.com>
Message-ID: <d7498224939266fa1205d73fdc06b242@localhost>
User-Agent: RoundCube Webmail/0.1-rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 09 Nov 2011 11:40:01 +0100, Gerd Hoffmann wrote:



> far I know it is pretty much impossible to figure the

> foreground/background colors of the terminal you are running on.  You

> can try some guesswork based on $TERM (linux console usually has black

> background, xterm is white by default), but there will always be cases

> where it fails.



You can make it more explicit, similar to .vimrc:



:set background=dark or :set background=light which in turn set the

appropriate foreground colors.





Hagen 
