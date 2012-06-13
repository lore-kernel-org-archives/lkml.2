Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab2FMHyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:54:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab2FMHyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:54:05 -0400
Message-ID: <4FD8470B.8010507@redhat.com>
Date: Wed, 13 Jun 2012 09:53:47 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 3/3] deal with guest panicked event
References: <4FB9E4CE.8060709@cn.fujitsu.com> <4FB9E5CB.2020208@cn.fujitsu.com> <4FD74447.2090906@redhat.com> <4FD83B20.9060203@cn.fujitsu.com>
In-Reply-To: <4FD83B20.9060203@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/06/2012 09:02, Wen Congyang ha scritto:
>>> >> +Other possible actions are:
>>> >> +@code{pause} (emit QEVENT_GUEST_PANICKED and pause VM),
>>> >> +@code{quit} (emit QEVENT_GUEST_PANICKED and quit VM).
>> > 
>> > Rather than just "quit", there should be choices for "shutdown",
>> > "poweroff" and "reset" for consistency with -watchdog-action.
> Hmm, quit means poweroff. I will add reset, but I think we donot
> need shutdown, because we cannot shutdown the system when it is
> panicked.

Right. :)

Can you also rename quit to poweroff?

>> > Also, this option should also be accessible from "-machine", please.
> I don't understand this. Do you mean we can also specify this action
> in -machine option?

Yes, like -machine panic_action=poweroff.

Paolo
