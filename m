Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab2JCKxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 06:53:46 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62763 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab2JCKxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 06:53:44 -0400
Message-ID: <506C192E.5060700@redhat.com>
Date: Wed, 03 Oct 2012 12:53:34 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Lendacky <tahm@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, avi@redhat.com,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH 0/3] virtio-net: inline header support
References: <cover.1348824232.git.mst@redhat.com> <87vces2gxq.fsf__45058.6618776017$1349247807$gmane$org@rustcorp.com.au>
In-Reply-To: <87vces2gxq.fsf__45058.6618776017$1349247807$gmane$org@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/10/2012 08:44, Rusty Russell ha scritto:
> There's a reason I haven't done this.  I really, really dislike "my
> implemention isn't broken" feature bits.  We could have an infinite
> number of them, for each bug in each device.

However, this bug affects (almost) all implementations and (almost) all
devices.  It even makes sense to reserve a transport feature bit for it
instead of a device feature bit.

Paolo
