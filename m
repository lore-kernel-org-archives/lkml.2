Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab1CVStC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:49:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671Ab1CVStA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:49:00 -0400
MIME-Version: 1.0
In-Reply-To: <20110322183919.GV22723@ZenIV.linux.org.uk>
References: <20110322152602.053930811@szeredi.hu> <AANLkTinxD2rZnso3zfX0=-HQ9m7=zAjEtUepFO=uMe2Q@mail.gmail.com>
 <20110322183919.GV22723@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 Mar 2011 11:48:11 -0700
Message-ID: <AANLkTinU-F+fHaG9u7c4Tf0GNx5BJvHg7BGOAFGaiDn1@mail.gmail.com>
Subject: Re: [PATCH 0/6 v7] overlay filesystem - request for inclusion
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 11:39 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Locking analysis would be really nice; AFAICS, it violates locking order
> when called from e.g. ->setattr() and its protection against renames is
> nowhere near enough.  I might be missing something subtle, but...

Miklos - have you tried using this with lockdep (together with the
same filesystems mounted natively too)? I'd expect that that should
show any bad lock usage..

                   Linus
