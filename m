Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab2HNT7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 15:59:01 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34325 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab2HNT67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 15:58:59 -0400
MIME-Version: 1.0
In-Reply-To: <87boidgvaq.fsf@codemonkey.ws>
References: <5021D235.4050800@cn.fujitsu.com>
	<20120813182132.GB25268@amt.cnet>
	<20120814085619.GA32708@redhat.com>
	<502A2B7A.3070801@siemens.com>
	<86E2467F-0EA3-4A03-BD89-58E41F7DB808@redhat.com>
	<20120814154237.GA21284@amt.cnet>
	<87boidgvaq.fsf@codemonkey.ws>
Date: Tue, 14 Aug 2012 20:58:58 +0100
Message-ID: <CAFEAcA-yfqWpRH2mGgiY6uPNF8WQNB3po8yLANAkQYwa+RS+xQ@mail.gmail.com>
Subject: Re: [Qemu-devel] [PATCH v8] kvm: notify host when the guest is panicked
From: Peter Maydell <peter.maydell@linaro.org>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Yan Vugenfirer <yvugenfi@redhat.com>, kvm list <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 August 2012 19:53, Anthony Liguori <anthony@codemonkey.ws> wrote:
> Forget about !x86 platforms.  They have their own way to do this sort of
> thing.  Think of this feature like a status LED on a motherboard.  These
> are very common and usually controlled by IO ports.

Please don't forget !x86 platforms, we are cute and loveable really :-)

> We're simply reserving a "status LED" for the guest to indicate that it
> has paniced.  Let's not over engineer this.

...not that QEMU actually has any kind of "front panel lights and switches"
interface at all, it might be nice to have one. I bet a lot of the embedded
boards have function DIP switches, heartbeat LEDs, etc etc...

-- PMM
