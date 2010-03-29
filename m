Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab0C2Jne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 05:43:34 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60714 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab0C2Jnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 05:43:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=JQKc7Kp9fXa8CEQY5EPFAPiR/Dq4jk3EC0pdfgxI6Hvtlzv0jTDAjSgCeWh4ZnSR/L
         VFc0GJ7qUKwwK3uG6RnRLEsI1h4wRticZiCYQUJvWqnDLGKU2vNsTXe9RlsCDfA+07zR
         CfA1ECz4sk/10MBQOmGCQQyT+ixkfrpGj/gxM=
Date: Mon, 29 Mar 2010 12:43:22 +0300
From: Dan Carpenter <error27@gmail.com>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: wbhal_f.h Coding style fixes.
Message-ID: <20100329094322.GB15060@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Lars Lindley <lindley@coyote.org>, gregkh@suse.de, greg@kroah.com,
	penberg@cs.helsinki.fi, pavel@ucw.cz, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1269796259-8671-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269796259-8671-1-git-send-email-lindley@coyote.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 07:10:59PM +0200, Lars Lindley wrote:
> I fixed all checkpatch problems and also converted the
> function arguments from hungarian notation and CamelCase.
> 

	[snip]

> -#define hal_ibss_disconnect(_A) hal_stop_sync_bss(_A)
> +#define hal_ibss_disconnect(_A)		(hal_stop_sync_bss(_A))

The parenthesis around hal_stop_sync_bss() aren't needed.  They don't
hurt anything, but they're odd.

Also it appears that no one uses hal_ibss_disconnect().

So far as I'm concerned this can go in as is...
Acked-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter

