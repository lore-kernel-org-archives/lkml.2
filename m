Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab2CIQO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 11:14:59 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52106 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab2CIQO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 11:14:57 -0500
MIME-Version: 1.0
In-Reply-To: <20120309151951.GA30160@redhat.com>
References: <20120306185137.GA15881@redhat.com> <20120306210307.GC8781@quack.suse.cz>
 <20120307072608.GA24087@localhost> <20120307104240.GB18658@quack.suse.cz>
 <CAO_0yfNt2jgiTPZn5NkwBAjQZtk+377gG71d6QOuXQrDHjdkEg@mail.gmail.com>
 <20120309145713.GA21543@redhat.com> <20120309151951.GA30160@redhat.com>
From: Yang Bai <hamo.by@gmail.com>
Date: Sat, 10 Mar 2012 00:14:37 +0800
Message-ID: <CAO_0yfMYOOTvRg9=8_eYP09o0BpzSEk=8vqgNk_vV_u3-biAYA@mail.gmail.com>
Subject: Re: inode->i_wb_list corruption.
To: Dave Jones <davej@redhat.com>, Yang Bai <hamo.by@gmail.com>,
        Jan Kara <jack@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>,
        viro@zeniv.linux.org.uk, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 11:19 PM, Dave Jones <davej@redhat.com> wrote:
> And with that, this arrived..
> https://bugzilla.redhat.com/show_bug.cgi?id=788433#c3
>
> I'm leaning strongly towards believing this is yet another case of i915
> corrupting memory on resume.
>

Nice catch. I am wondering
1) why all lists being affected and
2) why all list_head's prev being set to NULL.

Any ideas?

Thanks,
Yang
