Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab1EVTv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 15:51:27 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48140 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab1EVTvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 15:51:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=F3CvZRm3gmOOJGFwvTi5GDbsKkfrObUAUt5l5I4xFavAqsYERrBslWfPyng6MGDZi4
         9HPUxJzN8BxhDaznkVbauc8QOdWFK5dZ6No6DT4rV1BgxSkEwO9am5YKsxW8C0sRaoP+
         9CsdS+VPDqetVSEJ2X3+KRtRB535etjrdm7hM=
MIME-Version: 1.0
In-Reply-To: <1306092879.16902.1.camel@monotop>
References: <1306092879.16902.1.camel@monotop>
Date: Sun, 22 May 2011 21:51:19 +0200
Message-ID: <BANLkTikiLj5O6sNH0vrxwNJKMA1QcqB0DA@mail.gmail.com>
Subject: Re: [PATCH] fs: add missing prefetch header to inode.c
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Eduardo Silva <edsiper@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 22, 2011 at 9:34 PM, Eduardo Silva <edsiper@gmail.com> wrote:
> inode.c fails in the compilation process due to the missing
> include of linux/prefetch.h.

On which arch?
So far I've observed this build error only on UML.
A fix has already been submitted.

-- 
Thanks,
//richard
