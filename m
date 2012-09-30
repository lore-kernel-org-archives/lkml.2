Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab2I3JlD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 05:41:03 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57184 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab2I3JlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 05:41:00 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.106.0]
In-Reply-To: <20120925070251.GC23009@elgon.mountain>
References: <20120925070251.GC23009@elgon.mountain>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 30 Sep 2012 11:40:40 +0200
Message-ID: <CAK=WgbbgWicLygZgkkiSYOrCorKJB6Xr71uLX_4F_ZNwmszc7A@mail.gmail.com>
Subject: Re: [patch 2/3] remoteproc: snprintf() can return more than was printed
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 9:02 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> snprintf() returns the number of characters which would have been
> printed if there were enough space.  For example, on the first print if
> we fill up the 28 character string then it would return a number more
> than 30.  Use scnprintf() instead because that returns the actual number
> of characters printed.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks.
