Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab1DSBjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 21:39:14 -0400
Received: from ozlabs.org ([203.10.76.45]:46927 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab1DSBjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:39:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jonathan Cameron <jic23@cam.ac.uk>, linux-kernel@vger.kernel.org
Cc: greg@kroah.com, adobriyan@gmail.com, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH 1/3] Add a usr_strtobool function matching semantics of existing in kernel equivalents
In-Reply-To: <1300973025-32497-2-git-send-email-jic23@cam.ac.uk>
References: <1300973025-32497-1-git-send-email-jic23@cam.ac.uk> <1300973025-32497-2-git-send-email-jic23@cam.ac.uk>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Tue, 19 Apr 2011 11:06:23 +0930
Message-ID: <87oc433tuw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 13:23:43 +0000, Jonathan Cameron <jic23@cam.ac.uk> wrote:
> This is a renamed and relocated fixed version of previous kstrtobool RFC

Please just call it strtobool, usr_ implies it's a user pointer.

And there's no need to introduce a new var in debugfs, just do:

	if (strtobool(buf, &bv) == 0)
		*val = bv;

And yes, I'll take it for the param stuff.

Thanks,
Rusty.
