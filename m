Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab1CVRhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 13:37:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755185Ab1CVRg7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 13:36:59 -0400
MIME-Version: 1.0
In-Reply-To: <20110322152602.053930811@szeredi.hu>
References: <20110322152602.053930811@szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 Mar 2011 10:36:09 -0700
Message-ID: <AANLkTinxD2rZnso3zfX0=-HQ9m7=zAjEtUepFO=uMe2Q@mail.gmail.com>
Subject: Re: [PATCH 0/6 v7] overlay filesystem - request for inclusion
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 8:26 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Here's an updated version of the overlay filesystem.  I'd like to
> propose it for inclusion into mainline.

So on the whole it looked pretty small and simple. And most of the VFS
level changes looked fine and I just reacted to the odd calling
convention for open (I really think you should aim for ->open to have
the basically same arguments as you made __dentry_open have: 'struct
path', 'struct filp' and 'struct cred').

But I'd want Al's ack on the series. And also hear who uses it and how
it's been tested?

                                Linus
