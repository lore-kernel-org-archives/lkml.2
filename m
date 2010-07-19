Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967129Ab0GSWje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 18:39:34 -0400
Received: from tex.lwn.net ([70.33.254.29]:42241 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967071Ab0GSWjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 18:39:33 -0400
Date: Mon, 19 Jul 2010 16:39:30 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 4/4] drivers/media/video: Remove dead CONFIG_OLPC_X0_1
Message-ID: <20100719163930.6c3333a7@bike.lwn.net>
In-Reply-To: <966ac7deeee8b102b9b8d829ca14e177f9368f21.1279111369.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1279111369.git.qy03fugy@stud.informatik.uni-erlangen.de>
	<966ac7deeee8b102b9b8d829ca14e177f9368f21.1279111369.git.qy03fugy@stud.informatik.uni-erlangen.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010 15:21:48 +0200
Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de> wrote:

> CONFIG_OLPC_X0_1 doesn't exist in Kconfig and is never defined anywhere
> else, therefore removing all references for it from the source code.

That symbol is, needless to say, an OLPC thing; it's in their
repository.  I do think they plan to upstream all of that at some
point, but I think they're a little busy at the moment.

Deleting this code will increase the delta between the OLPC and
mainline trees.  My preference would be for that not to happen.  If it
does, though, life will obviously go on, and this code can be restored
when the rest is upstreamed.  If you must do that, though, could I ask
that you preserve the CONFIG_OLPC_XO_1 version of the code, which is
the version which has traditionally been in the mainline?

jon
