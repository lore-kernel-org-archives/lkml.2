Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab2GQMDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 08:03:44 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46404 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab2GQMDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 08:03:41 -0400
MIME-Version: 1.0
In-Reply-To: <20120717115450.GA9796@redhat.com>
References: <1342107302-28116-1-git-send-email-asias@redhat.com>
	<CAJSP0QWgmXns89se+xdGgM6i1_hsfVWPQ8caHua9d-dDA4CTDQ@mail.gmail.com>
	<50052276.2080906@redhat.com>
	<500527BA.9000001@redhat.com>
	<50052E7E.6020100@redhat.com>
	<CAJSP0QW0tPV3WASGOBRE4hL=8zzSFQ6T=bHbEwMAzmHR9wnwJg@mail.gmail.com>
	<20120717112645.GA9363@redhat.com>
	<CAJSP0QXPkrVvgA+1fhhwsB5J8oApOObK8D3fk_Lm0Bt3T+Wfuw@mail.gmail.com>
	<20120717115450.GA9796@redhat.com>
Date: Tue, 17 Jul 2012 13:03:39 +0100
Message-ID: <CAJSP0QXwGuUaD9piktOptJasdpci_fA90d=vV4m0SuORMvc2=Q@mail.gmail.com>
Subject: Re: [PATCH 0/5] Add vhost-blk support
From: Stefan Hajnoczi <stefanha@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Asias He <asias@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 12:54 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
>> Knowing the answer to that is important before anyone can say whether
>> this approach is good or not.
>>
>> Stefan
>
> Why is it?

Because there might be a fix to kvmtool which closes the gap.  It
would be embarassing if vhost-blk was pushed just because no one
looked into what is actually going on.

And on the flipside, hard evidence of an overhead that cannot be
resolved could be good reason to do more vhost devices in the future.
Either way, it's useful to do this before going further.

Stefan
