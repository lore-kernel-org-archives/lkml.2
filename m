Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab1LLVlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:41:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59585 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1LLVlG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:41:06 -0500
MIME-Version: 1.0
In-Reply-To: <1319461948.31243.31.camel@deadeye>
References: <1319461948.31243.31.camel@deadeye>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 12 Dec 2011 13:40:44 -0800
X-Google-Sender-Auth: Y_3T8BlTpGhxADUfbMgx-U_Bq28
Message-ID: <CAB=NE6Vt91tHCBj7sJHjUCaDZZPqox+omcQjsEj54vQAtbY2bw@mail.gmail.com>
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not
 built in-tree
To: Ben Hutchings <ben@decadent.org.uk>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Greg KH <greg@kroah.com>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 6:12 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
> Use of the GPL or a compatible licence doesn't necessarily make the code
> any good.  We already consider staging modules to be suspect, and this
> should also be true for out-of-tree modules which may receive very
> little review.
>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> Debian has been carrying this for the last few kernel versions.  The
> recent thread '[RFC] virtualbox tainting.' and discussions at KS suggest
> that this might be more generally useful.

This indeed seems like a good idea to advocate getting things upstream
(not just staging) but what about the case where we have upstream
drivers from future kernels backported to older kernels and the newer
driver is simply provided as a feature for users who may need new
features / chipset support on their old distribution kernel?

It seems this taint flag will be used for driers backported through
compat-wireless, the compat kernel module or any other backported
driver, even if it is indeed upstream and whereby kernel developer
*do* commit to actually fixing issues. In our experience
compat-wireless bugs *are real bugs*, not backport bugs so we do look
into them. In our latest linux-next.git based release for example
backport code consists only of 1.3804% of the code.

  Luis
