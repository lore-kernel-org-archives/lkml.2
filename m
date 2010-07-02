Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab0GBSZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 14:25:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756701Ab0GBSZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 14:25:12 -0400
Date: Fri, 2 Jul 2010 11:24:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: mmotm 2010-07-01-12-19 uploaded
Message-Id: <20100702112458.5af7ab81.akpm@linux-foundation.org>
In-Reply-To: <AANLkTil8PSxIkp_Bv4bomZkaLOfVX__dgW3XDVxjnxF8@mail.gmail.com>
References: <201007011948.o61JmnT2022795@imap1.linux-foundation.org>
	<AANLkTil8PSxIkp_Bv4bomZkaLOfVX__dgW3XDVxjnxF8@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jul 2010 17:26:11 +0800 Xiaotian Feng <xtfeng@gmail.com> wrote:

> On Fri, Jul 2, 2010 at 3:19 AM,  <akpm@linux-foundation.org> wrote:
> > The mm-of-the-moment snapshot 2010-07-01-12-19 has been uploaded to
> >
> > __ http://userweb.kernel.org/~akpm/mmotm/
> >
> > and will soon be available at
> >
> > __ git://zen-kernel.org/kernel/mmotm.git
> >
> > It contains the following patches against 2.6.35-rc3:
> >
> 
> I'm running into an oops with -mmotm. It might be drm related, I don't
> have a camera on my hand.

Cellphone cameras work.

> So I type the oops manually. My config is
> attached. Any ideas on the oops? Thanks
> 
> bad_area+0x42/0x49
> do_page_fault+0x206/
> page_fault+0x25/0x38
> ? __list_add+0x3f/0x81
> ? might_fault+0x1c/0x1e
> __mutex_lock_common+0xc6/
> ? drm_version+0x0/0x9c
> __mutex_lock_slowpath
> mutex_lock+0x31/0x4b
> drm_fb_release+0x28/0x75
> drm_release+0x36d/0x5e4
> fput+0x120/0x1cd
> filp_close+0x63/0x6d
> sys_close+0x98/0xcd
> system_call_fastpath

Yup, that looks DRm-related.  cc added.
