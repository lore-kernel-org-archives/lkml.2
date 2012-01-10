Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab2AJDBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 22:01:12 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41947 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944Ab2AJDBL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 22:01:11 -0500
MIME-Version: 1.0
In-Reply-To: <1326160956.6802.76.camel@haakon2.linux-iscsi.org>
References: <CAE8XmWoi7MpciKfA4t+NeKAX2zZCmHbB6PCYMG4WnhGA_k5jrQ@mail.gmail.com>
 <1326160956.6802.76.camel@haakon2.linux-iscsi.org>
From: Dongsheng Song <dongsheng.song@gmail.com>
Date: Tue, 10 Jan 2012 11:00:48 +0800
Message-ID: <CAE8XmWp9L4BVL00k1zjhpsV1ikkHcr-xzjBmomDvG=CTmGto+g@mail.gmail.com>
Subject: Re: Where is module target_core_stgt or forgot cleanup ?
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 10:02, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> Hello,
>
> target_core_stgt is a backend driver for a userspace passthrough using
> STGT logic that exists in lio-core.git code.  It's only WIP code in it's
> current form, and until someone shows interest in doing the necessary
> work to make it run it's going to remaine a lio-core.git specific
> module.
>
> --nab
	
Thank you, I got it.

So ' request_module("target_core_stgt")' should be remove from
the mainline kernel code, isn't it?

--
Dongsheng
