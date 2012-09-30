Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751032Ab2I3J2u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 05:28:50 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36796 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab2I3J2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 05:28:48 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.106.0]
In-Reply-To: <20120925070156.GB23009@elgon.mountain>
References: <20120925070156.GB23009@elgon.mountain>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 30 Sep 2012 11:28:27 +0200
Message-ID: <CAK=Wgbbk1MvH_ct8RLz+6bkG7fauBtUZeCVvB+yj68V0Kr9TNw@mail.gmail.com>
Subject: Re: [patch 1/3] remoteproc: memory leak in rproc_handle_carveout()
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 9:01 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> We only need to allocate mapping if there is an rproc domain.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Static checker stuff.  Handle with appropriate caution.

Applied, thanks.

I'm just changing the subject, because this actually fixes a sneaky
NULL-dereference and not a memory leak.
