Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0FDHjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:39:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57553 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab0FDHjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:39:42 -0400
Date: Fri, 4 Jun 2010 08:39:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@parisplace.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ima-user@lists.sourceforge.net,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Roberto Sassu <roberto.sassu@polito.it>
Subject: Re: [PATCH][1/1] fs: wrong type for 'magic' argument in
 'simple_fill_super()', fs/libfs.c
Message-ID: <20100604073940.GD31073@ZenIV.linux.org.uk>
References: <201006011906.00880.roberto.sassu@polito.it>
 <AANLkTik2J7LTYYpWIQOE2IgsRhtP4Z-9MEd39qbtYyxr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik2J7LTYYpWIQOE2IgsRhtP4Z-9MEd39qbtYyxr@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 10:06:27AM -0400, Eric Paris wrote:
> Al,
> 
> Can you add the following and push this along to Linus on your next go?

Applied with trivial modification, but... that's not going to make
kABI lovers happy; it's a genuine silent ABI change.  Oh, well...
