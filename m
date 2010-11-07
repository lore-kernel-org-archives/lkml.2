Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab0KGHzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 02:55:48 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56050 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab0KGHzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 02:55:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PizAsAlpuqZCTaMuWlesgcusGxeWulGOaCJUBiqrHhBEZK5BTFQqiMmQ6TZwzsHY+V
         Dp0iW1l7ryWJNDucx3HTX5qvxSghFGrQx2BxQ7itc1WYzLNLPPOvLpUttGXEKel7XVNP
         p4BM+D0NlImjHi2ZQnGGnD82km27RW2OfzfS8=
Date: Sun, 7 Nov 2010 15:58:41 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Kirill A. Shutsemov" <kirill@shutemov.name>
Cc: Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kbuild: introduce ARCH_LIST for headers_install_all
Message-ID: <20101107075841.GM3046@hack>
References: <1288357441-23100-1-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288357441-23100-1-git-send-email-kirill@shutemov.name>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 04:04:00PM +0300, Kirill A. Shutsemov wrote:
>From: Kirill A. Shutemov <kirill@shutemov.name>
>
>Using ARCH_LIST you can specify subset of architectures you want to get
>headers for.
>

The name is confusing, I think HEADER_ARCH_LIST is much better. :)

-- 
Live like a child, think like the god.
 
