Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab1IZTph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 15:45:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34540 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab1IZTpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 15:45:36 -0400
MIME-Version: 1.0
In-Reply-To: <1317065842.20885.3.camel@lappy>
References: <1317058869-19276-1-git-send-email-levinsasha928@gmail.com>
	<20110926184445.GA22278@redhat.com>
	<1317065842.20885.3.camel@lappy>
Date: Mon, 26 Sep 2011 22:45:35 +0300
X-Google-Sender-Auth: 5nGchb4Ru-Oal73T8CurLHfatHY
Message-ID: <CAOJsxLHQZCvRQMcs08GZgDgR9AwtePdr=t7kos6XfMF_dgxZGw@mail.gmail.com>
Subject: Re: [PATCH 1/2] virtio-net: Verify page list size before fitting into skb
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 10:37 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>> Interesting.  This is a theoretical issue, correct?
>> Not a crash you actually see.
>
> Actually it was an actual crash caused when our virtio-net driver in kvm
> tools did funny things and passed '(u32)-1' length as a buffer length to
> the guest kernel.

I'm not sure what Michael means with "theoretical issue" here. Can the guest
driver assume that the hypervisor doesn't attempt to do nasty things?

                          Pekka
