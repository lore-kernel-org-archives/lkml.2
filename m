Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1E3BsW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 21:48:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752920Ab1E3BsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 21:48:21 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
References: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 29 May 2011 18:47:57 -0700
Message-ID: <BANLkTinsO2=tO_UyzzgeU6LE1fObgq+p1Q@mail.gmail.com>
Subject: Re: Linux 3.0-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, and as some people already noticed, the numbering means that the
tar-balls and patches are now in a new directory:

    /pub/linux/kernel/v3.0

(under "testing/", since that's what we do with -rc releases).
However, I did *not* rename the git tree, because that would just be a
huge inconvenience to git users, so it's still in the same old place
and yes, that means that my git tree is still called "linux-2.6.git"
on kernel.org. But it has the v3.0-rc1 tag in it.

I'll probably add a symlink or something, if people really hate being
reminded about our long history with the "2.6" numbering. But that
won't be until closer to the real release, methinks.

                            Linus
