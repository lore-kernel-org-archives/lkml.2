Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab1DCKKG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 06:10:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62753 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab1DCKKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 06:10:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TfFz5/mcCXYoI3wb7q/dMbgOyUsBY5UmBwT2QyYTcQHRe+UZmCUQML1EKwNxlEU/qj
         UxP6stlYMgf9uBWq9aUgcCbPPqsPY+H8KcUACPUTTDmJmIKbWgCsXxG7lMap0cZsXGQ/
         VuHvGwA+jFpwMXkY1e3XjJ7iiLmzqX0cPK94s=
Date: Sun, 3 Apr 2011 13:09:59 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: bookjovi@gmail.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: update file header info correctly
Message-ID: <20110403100959.GA4834@p183.telecom.by>
References: <1301455753-2866-1-git-send-email-bookjovi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301455753-2866-1-git-send-email-bookjovi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 11:29:13PM -0400, bookjovi@gmail.com wrote:
> From: Jovi Zhang <bookjovi@gmail.com>
> 
> After some files changed location from drivers/char to driver/tty,
> file header info also need to update

They should be _removed_ exactly to avoid this kind of patches.
