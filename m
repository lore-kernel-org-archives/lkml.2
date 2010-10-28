Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349Ab0J1Wew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 18:34:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753285Ab0J1Weq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 18:34:46 -0400
MIME-Version: 1.0
In-Reply-To: <20101028222404.GG2715@dastard>
References: <1288303325-9628-1-git-send-email-zohar@linux.vnet.ibm.com> <20101028222404.GG2715@dastard>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 28 Oct 2010 15:29:21 -0700
Message-ID: <AANLkTimG6o66SFHskkDOtLqYeSzwKt2c0jR3CWe+sd2w@mail.gmail.com>
Subject: Re: [PATCH 0/4] IMA: making i_readcount a first class inode citizen
To: Dave Chinner <david@fromorbit.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, warthog9@kernel.org, jmorris@namei.org,
        kyle@mcmartin.ca, hpa@zytor.com, akpm@linux-foundation.org,
        mingo@elte.hu, eparis@redhat.com, viro@zeniv.linux.org.uk,
        Matthew Wilcox <matthew@wil.cx>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 3:24 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Why the wrapper functions and locking? Why not an atomic variable like
> i_writecount?

Indeed. With moving this more into the VFS, let's just make sure it
looks like i_writecount as much as possible.

                      Linus
