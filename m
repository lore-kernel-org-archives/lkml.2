Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab2CaS3P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 14:29:15 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63043 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab2CaS3M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 14:29:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120331051906.GU6589@ZenIV.linux.org.uk>
References: <20120331051906.GU6589@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 31 Mar 2012 11:28:50 -0700
X-Google-Sender-Auth: -yDgU3iMAa5bnbFHQrmL2qqqT8w
Message-ID: <CA+55aFxmOEUCXeHtSAN+g3cSpFVvf5vPTSzZDtXdJs0Hq1rVZw@mail.gmail.com>
Subject: Re: [git pull] vfs part 2
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 10:19 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>        Miklos' first series (with do_lookup() rewrite split into edible
> chunks) + assorted bits and pieces.

Hmm. This oopses at boot in d_alloc() (or similar) for me. It's in
some initcall, very early, before user space has even started.

It may be some other change than your pull... I will explore more, but
I thought I'd let you know that it's the prime suspect right now.

                            Linus
