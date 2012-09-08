Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2IHKcO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 06:32:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45257 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab2IHKcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 06:32:11 -0400
Message-ID: <504B1EA6.8050304@redhat.com>
Date: Sat, 08 Sep 2012 12:32:06 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Michael S. Tsirkin" <mst@redhat.com>, fes@google.com, aarcange@redhat.com,
        riel@redhat.com, kvm@vger.kernel.org, yvugenfi@redhat.com,
        linux-kernel@vger.kernel.org, mikew@google.com, yinghan@google.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-balloon spec: provide a version of the "silent
 deflate" feature that works
References: <1346917610-14568-1-git-send-email-pbonzini@redhat.com> <20120906084736.GF17656@redhat.com> <50486BB2.7070108@redhat.com> <20120906094442.GA22816@redhat.com> <50487382.8030303@redhat.com> <20120906105301.GC32325@redhat.com> <5048935A.8090308@redhat.com> <87wr06hg0l.fsf@rustcorp.com.au> <20120907054202.GA3452@redhat.com> <87vcfqfia1.fsf@rustcorp.com.au> <20120907104306.GA17211@redhat.com> <87sjatf6iv.fsf@rustcorp.com.au>
In-Reply-To: <87sjatf6iv.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08/09/2012 07:06, Rusty Russell ha scritto:
>> > Do we really know there are no hypervisors implementing it?
> As much as can be known.  Qemu doesn't, lkvm doesn't.
> 

However, there are cases in which it would be nice to have it.
Repurposing the bit to how it has been used so far (as a guest->host
communication bit, not host->guest) is a better choice.

Paolo
