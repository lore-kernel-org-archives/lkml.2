Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab0HXGZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 02:25:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752871Ab0HXGZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 02:25:26 -0400
Date: Mon, 23 Aug 2010 23:28:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Roland McGrath <roland@redhat.com>
Subject: Re: [RFC PATCH v3] core_pattern: fix long parameters was truncated
 by core_pattern handler
Message-Id: <20100823232819.38869a41.akpm@linux-foundation.org>
In-Reply-To: <4C736438.8010206@redhat.com>
References: <20100803105941.GA2996@hmsreliant.think-freely.org>
	<1282296958-2427-1-git-send-email-dfeng@redhat.com>
	<20100823141843.f177bf1f.akpm@linux-foundation.org>
	<4C736438.8010206@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 14:18:32 +0800 Xiaotian Feng <dfeng@redhat.com> wrote:

> >
> > Something like this, although I didn't try very hard.  Just a
> > suggestion to work with ;)
> >
> Yep,  we just need change a little on your patch
> 
> 	- err = cn_printf(cn, "%%");
> 	+ err = cn_printf(cn, "%");

whoa.  Closer than I usually achieve.

> Do you need me to resend a v4 patch?

Yes please - something which was nicely tested ;)
