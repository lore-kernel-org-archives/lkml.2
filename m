Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab2ILQr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:47:29 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36956 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab2ILQr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:47:28 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Maxim V. Patlasov" <mpatlasov@parallels.com>
Cc: "fuse-devel\@lists.sourceforge.net" 
	<fuse-devel@lists.sourceforge.net>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel\@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH 0/6] fuse: allocate req->pages[] dynamically
References: <20120907172536.1343.80497.stgit@maximpc.sw.ru>
	<5050B336.1090500@parallels.com>
Date: Wed, 12 Sep 2012 18:49:01 +0200
In-Reply-To: <5050B336.1090500@parallels.com> (Maxim V. Patlasov's message of
	"Wed, 12 Sep 2012 20:07:18 +0400")
Message-ID: <87har3w5j6.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Maxim V. Patlasov" <mpatlasov@parallels.com> writes:

> Hi Miklos,
>
> So far as no objections appeared, I'll go ahead and replace fuse req->page with
> req->pagevec. It will point to an array of structs:
>
> struct page_vec {
>     struct page    *pv_page;
>     unsigned int    pv_len;
>     unsigned int    pv_offset;
> };
>
> instead of 'struct page *' as it used to be. It seems to be what you suggested
> in one of your comments. Are you OK about it?

Yes, that's exactly what I was thinking.

Thanks,
Miklos
