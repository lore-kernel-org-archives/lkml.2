Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab2GXFRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 01:17:07 -0400
Received: from ozlabs.org ([203.10.76.45]:33021 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab2GXFRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 01:17:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <levinsasha928@gmail.com>, mst@redhat.com, penberg@kernel.org,
        asias.hejun@gmail.com
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, anthony@codemonkey.ws,
        wency@cn.fujitsu.com, Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [RFC 0/2] virtio: provide a way for host to monitor critical events in the device
In-Reply-To: <1343075561-29316-1-git-send-email-levinsasha928@gmail.com>
References: <1343075561-29316-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 24 Jul 2012 14:25:44 +0930
Message-ID: <87a9yprc4v.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2012 22:32:39 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
> As it was discussed recently, there's currently no way for the guest to notify
> the host about panics. Further more, there's no reasonable way to notify the
> host of other critical events such as an OOM kill.

I clearly missed the discussion.  Is this actually useful?  In practice,
won't you want the log from the guest?  What makes a virtual guest
different from a physical guest?

Guest watchdog functionality might be useful, but that's simpler to
implement via a virtio watchdog device, and more effective to implement
via a host facility that actually pings guest functionality (rather than
the kernel).

Cheers,
Rusty.
