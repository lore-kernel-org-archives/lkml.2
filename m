Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab1FUGly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 02:41:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48186 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab1FUGlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 02:41:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=i4NZk+kAa8rVt1wKC3RFPMh1zNSFkYNG/9wkfXbwDF32IKSCclEI/HQ6LXj18XizTt
         yMDUoKUfbHnA8yeWueM5xj5b+gXyGZCFiLRpKy/cLHwlMPYl33o0odJukmOivEC89us1
         54kJ7NJdECwoZCIJoAFt9SKGy3QYDSH73IjbQ=
MIME-Version: 1.0
In-Reply-To: <1308636747-2360-1-git-send-email-bebarino@gmail.com>
References: <1308636747-2360-1-git-send-email-bebarino@gmail.com>
Date: Tue, 21 Jun 2011 14:41:51 +0800
Message-ID: <BANLkTikmukNy0e8XHaAsFAtizKy5745K3Q@mail.gmail.com>
Subject: Re: [PATCH] configs: Include MODULE_*() when CONFIG_IKCONFIG_PROC=n
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Stephen Boyd <bebarino@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 2:12 PM, Stephen Boyd <bebarino@gmail.com> wrote:
> If CONFIG_IKCONFIG=m but CONFIG_IKCONFIG_PROC=n we get a module that has
> no MODULE_LICENSE definition. Move the MODULE_*() definitions outside
> the CONFIG_IKCONFIG_PROC #ifdef to prevent this configuration from
> tainting the kernel.
>
> Signed-off-by: Stephen Boyd <bebarino@gmail.com>
> Cc: Randy Dunlap <rdunlap@xenotime.net>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.
