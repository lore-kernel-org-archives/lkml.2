Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab2LAA4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 19:56:12 -0500
Received: from scrye.com ([75.148.32.185]:37313 "EHLO mail.scrye.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab2LAA4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 19:56:10 -0500
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] v3.0.x: mtd: check partition count not partition array pointer
From: Anthony Foiani <tkil@scrye.com>
Reply-To: Anthony Foiani <tkil@scrye.com>
X-Attribution: Tony
References: <gpq3oh9on.fsf@dworkin.scrye.com>
	<20121129213838.GA20660@kroah.com> <gvccm1v5b.fsf@dworkin.scrye.com>
	<20121201003201.GA18885@kroah.com>
Date: Fri, 30 Nov 2012 17:56:07 -0700
In-Reply-To: <20121201003201.GA18885@kroah.com> (Greg KH's message of "Fri, 30 Nov 2012 16:32:01 -0800")
Message-ID: <gmwxy1tg8.fsf@dworkin.scrye.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b31 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg --

Thanks for the very quick response.

Greg KH <greg@kroah.com> writes:
> This is an obvious one, it needs to be upstream first.
>
> Or if not, a whole lot of explaination saying that you know it
> isn't, and why it isn't, and why it isn't applicable there,

I thought that I did provide exactly this information, when I
indicated that this function no longer even existed in upstream.

The replacement in upstream was to fold this functionality into
another function -- but I found that function much more complex and
difficult to follow.

So I went with the simple fix.

> including agreement from the subsystem maintainers saying that they
> agree with you.

I also don't have that.  I might post it to the mtd list, to see if
they have any interest in either approving it as-is for 3.0 series, or
doing the backport of the current code.

Thanks again for your time.

Tony
