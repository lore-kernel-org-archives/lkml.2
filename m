Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084Ab0EYXkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 19:40:18 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37696 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab0EYXkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 19:40:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=i/MRPGmkv9IJkXTcb4rZBbDci5xAhi8U95IZ2vv83Dt5AgGnDR4t0NeTPoEtGOKT3p
         dsDgGHCrrZzQhWWyPr010OOD50TB/wsFsbd8iY0Svxvz28bSiIbKsjrPFjQDu3NJ0RmW
         WN71B0iiNZDQzM57sWIHQcpTyLzGpHcwSyt60=
MIME-Version: 1.0
In-Reply-To: <1274825820-10246-2-git-send-email-albert_herranz@yahoo.es>
References: <1274825820-10246-1-git-send-email-albert_herranz@yahoo.es>
	 <1274825820-10246-2-git-send-email-albert_herranz@yahoo.es>
Date: Wed, 26 May 2010 07:40:13 +0800
Message-ID: <AANLkTikQ2cf_9P1DIVw5CV6NKHVhp10WyFBJW6J1yZY5@mail.gmail.com>
Subject: Re: [RFT PATCH 2/2] fb_defio: redo fix for non-dirty ptes
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: Albert Herranz <albert_herranz@yahoo.es>
Cc: npiggin@suse.de, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 6:17 AM, Albert Herranz <albert_herranz@yahoo.es> wrote:
> As pointed by Nick Piggin, ->page_mkwrite provides a way to keep a page
> locked until the associated PTE is marked dirty.
>
> Re-implement the fix by using this mechanism.
>
> LKML-Reference: <20100525160149.GE20853@laptop>
> Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>

Looks good to me. Thanks.

Acked-by: Jaya Kumar <jayakumar.lkml@gmail.com>
