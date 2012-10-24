Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935027Ab2JXOf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:35:27 -0400
Received: from tex.lwn.net ([70.33.254.29]:45757 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934968Ab2JXOfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:35:24 -0400
Date: Wed, 24 Oct 2012 08:36:48 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Ed Cashin <ecashin@coraid.com>
Cc: rob@landley.net, linux-doc@vger.kernel.org, dan.carpenter@oracle.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/SubmittingPatches: implicit permission
 for public reports
Message-ID: <20121024083648.5976519f@lwn.net>
In-Reply-To: <623a994357ba3348d5a4a0a2003b4dc0@coraid.com>
References: <623a994357ba3348d5a4a0a2003b4dc0@coraid.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012 10:22:02 -0400
Ed Cashin <ecashin@coraid.com> wrote:

> +contribution.  Please note that this tag should not be added without
> +the reporter's permission unless the problem was reported in a public
> +forum.  That said, if we diligently credit our bug reporters, they

I know what you're getting at, but this reads as if one should add the tag
even if it's contrary to the reporter's wishes.  How about something like:

	If the bug report was via a private channel, please obtain the
	reporter's permission before adding this tag - or, even better,
	ask that the report be posted publicly.

?

jon
