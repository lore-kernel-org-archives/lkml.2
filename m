Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500Ab1D0Qqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:46:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38190 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab1D0Qqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:46:42 -0400
Date: Wed, 27 Apr 2011 17:46:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
Message-ID: <20110427164639.GD9487@ZenIV.linux.org.uk>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 03:49:49PM -0300, Thiago Farina wrote:
> This macro is arguably more readable than its variants:
> - !strcmp(a, b)
> - strcmp(a, b) == 0

Strongly NACKed.  As far as I'm concerned, it's in the same shitbucket as
bcopy(3), bzero(3) et.al.  Use idiomatic C; extensions of that kind are
*bad*, since new developers have to learn them.
