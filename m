Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab3ACX1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 18:27:00 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48714 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab3ACX05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 18:26:57 -0500
MIME-Version: 1.0
In-Reply-To: <20130103223801.GA4479@kroah.com>
References: <20130103214114.GA12392@kroah.com> <20130103223801.GA4479@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 Jan 2013 15:26:35 -0800
X-Google-Sender-Auth: jgEI1Cmk4o94Jxz9mmiVqxd4ztk
Message-ID: <CA+55aFxOjYvT6iEC51sga+rRy7Oc5oZ_P5OOz6PC=tytrp5gsw@mail.gmail.com>
Subject: Re: [GIT PATCH] Driver core __dev* removal patches for 3.8-rc2
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 3, 2013 at 2:38 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> Crap, I accidentally committed this file as part of the merge, sorry
> about that.  I can either recreate the tree without this file in it, or
> delete the file in a commit on top of this, or just let you remove the
> file.  Which is easier for you?

Just recreate the tree.

In fact, why isn't this all just one single scripted commit?

                  Linus
