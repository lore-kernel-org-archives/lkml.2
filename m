Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab2BFWlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:41:19 -0500
Received: from ozlabs.org ([203.10.76.45]:39197 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab2BFWlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:41:18 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <pawel.moll@arm.com>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: re: params: <level>_initcall-like kernel parameters
In-Reply-To: <1328180937.1888.18.camel@hornet.cambridge.arm.com>
References: <20120202095612.GA30632@elgon.mountain> <1328180937.1888.18.camel@hornet.cambridge.arm.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 07 Feb 2012 08:46:50 +1030
Message-ID: <87liofip4d.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Feb 2012 11:08:57 +0000, Pawel Moll <pawel.moll@arm.com> wrote:
> You're right, of course! The initcall_level_names is missing "early
> parameters" string as the first element of the array. Well spotted - may
> I asked what tool did you use to get this message?
> 
> Rusty, do you want me to re-send the patch with this string fixed? I
> think you have rebased it on top of your bool-param series?

An incremental patch is preferred.  I can fold it once it's done.

Thanks,
Rusty.
