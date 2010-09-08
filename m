Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0IHPzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:55:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61482 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab0IHPzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:55:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=s9kLg5tt+ciZTk7jW23aVrbPzI/mSK/2AjvMBYIp1FnkMY6GH5AhrvRkRkTQoP72O6
         PkZQIQxAoYAsZ7clW5t6ghia0RYiWGQHuy7/n2Jz4pBjNjfWf9fnmdgAv8N6/dkJ9xZO
         3bOaYt9t8dFrQZuR7rXTVaZXqkwYpLQLVaHy8=
MIME-Version: 1.0
In-Reply-To: <AANLkTikdHZY1sOJFCMn8Zaca2rO6MsbXL459LZ4HOJTk@mail.gmail.com>
References: <201008271537.35709.ptesarik@suse.cz>
	<AANLkTikZRiQ5jCpgp42LxtXb_S52sSUy7KP_=vZ3z4Tf@mail.gmail.com>
	<201009061647.02345.ptesarik@suse.cz>
	<201009071517.43009.ptesarik@suse.cz>
	<AANLkTikdHZY1sOJFCMn8Zaca2rO6MsbXL459LZ4HOJTk@mail.gmail.com>
Date: Wed, 8 Sep 2010 08:55:36 -0700
Message-ID: <AANLkTim5tRPOgxWXAc8nGW6YT59UEDqW-+OBowJmKFQM@mail.gmail.com>
Subject: Re: Serious problem with ticket spinlocks on ia64
From: Tony Luck <tony.luck@gmail.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 7, 2010 at 10:35 AM, Tony Luck <tony.luck@gmail.com> wrote:
> Started up a test with this patch on my 32-way to confirm.

Still running now (22 hours). So that one works too.

-Tony
