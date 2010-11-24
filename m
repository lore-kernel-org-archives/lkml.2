Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0KXKdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 05:33:36 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61726 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab0KXKdf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 05:33:35 -0500
MIME-Version: 1.0
X-Originating-IP: [109.186.68.251]
In-Reply-To: <1290554607.3647.12.camel@atlantis.mindbit.ro>
References: <1290526740-27624-1-git-send-email-ohad@wizery.com>
 <1290526740-27624-3-git-send-email-ohad@wizery.com> <1290554607.3647.12.camel@atlantis.mindbit.ro>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 24 Nov 2010 12:33:14 +0200
Message-ID: <AANLkTinqZ7sMK3kOVV-7UBwx2q9qPoVr3zbze9Qp+0cm@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] drivers: hwspinlock: add OMAP implementation
To: Ionut Nicu <ionut.nicu@mindbit.ro>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>, Simon Que <sque@ti.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 1:23 AM, Ionut Nicu <ionut.nicu@mindbit.ro> wrote:
> At iounmap_base you unmap state->io_base, but that's set only after this
> check. You should probably iounmap(io_base).

Of course. Thanks.


>
> Regards,
> Ionut.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
