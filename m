Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab0HaNeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 09:34:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042Ab0HaNeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 09:34:14 -0400
MIME-Version: 1.0
In-Reply-To: <4C7CFCAC.1080003@canonical.com>
References: <4C7CFCAC.1080003@canonical.com>
Date: Tue, 31 Aug 2010 06:33:33 -0700
Message-ID: <AANLkTimUisNx_eeBYiVWELQfmjiQZefnjTQv99A36ync@mail.gmail.com>
Subject: Re: [PATCH] mm: Fix hiding the stack guard page in proc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 31, 2010, Stefan Bader <stefan.bader@canonical.com> wrote:
>
> Maybe its would be worth moving the inlines to mm.h.

Yes, I think it would be a good idea to try to abstract it out a bit...

       Linus
