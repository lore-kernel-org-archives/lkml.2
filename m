Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab2AIBch (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 20:32:37 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34483 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab2AIBcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 20:32:36 -0500
MIME-Version: 1.0
In-Reply-To: <20120109121133.76f5b7c4a4780954c4562244@canb.auug.org.au>
References: <20120109121133.76f5b7c4a4780954c4562244@canb.auug.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 8 Jan 2012 17:32:14 -0800
X-Google-Sender-Auth: JpdxmwPaoM2RlihSGsfzcnBIegY
Message-ID: <CA+55aFyYR=66K721tVF3NgLg-MyFsVuy6kewJJBXaS1GVd+wXQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the vfs tree with Linus' tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 8, 2012 at 5:11 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Then again ... it looks like the vfs tree has other changes to the btrfs
> code so that I need the version from the vfs tree, not Linus' tree ...

The btrfs changes (at lest most of them) will come through the btrfs
tree, that's one of the reasons the vfs tree got re-built, afaik.

                      Linus
