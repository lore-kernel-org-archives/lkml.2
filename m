Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab2EYNlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:41:07 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60216 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab2EYNlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:41:04 -0400
Date: Fri, 25 May 2012 14:43:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] pipe: return -ENOIOCTLCMD instead of -EINVAL on unknown
 ioctl command
Message-ID: <20120525144359.712cb21d@pyramind.ukuu.org.uk>
In-Reply-To: <1337942353-30979-1-git-send-email-will.deacon@arm.com>
References: <1337942353-30979-1-git-send-email-will.deacon@arm.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012 11:39:13 +0100
Will Deacon <will.deacon@arm.com> wrote:

> As described in commit 07d106d0a ("vfs: fix up ENOIOCTLCMD error
> handling"), drivers should return -ENOIOCTLCMD if they receive an ioctl
> command which they don't understand. Doing so will result in -ENOTTY
> being returned to userspace, which matches the behaviour of the compat
> layer if it fails to translate an ioctl command.
> 
> This patch fixes the pipe ioctl to return -ENOIOCTLCMD instead of
> -EINVAL when passed an unknown ioctl command.
> 
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Will Deacon <will.deacon@arm.com>

Acked-by: Alan Cox <alan@linux.intel.com>
