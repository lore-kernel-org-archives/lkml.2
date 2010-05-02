Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab0EBSMP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 14:12:15 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:46243 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442Ab0EBSMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 14:12:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RdxwoHi0ft8pbVq9L02l5pMVTUyvkVwPlEQMHV7/eBmRc7lbT+KhNkpIW+I60iNJ9s
         y3dVVt4+ef/Rc02MRNg1crNC9qmLOXd5mxK5RxkJKpOrpfE78//zKNL1I+Q+osdHEeD8
         4jwVkLNlwf+GuqWxp9MhJN95e+BXbc98pv1Bk=
MIME-Version: 1.0
In-Reply-To: <20100430120703.ffab0258.akpm@linux-foundation.org>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
	 <d5c4e26cc74458dd77102c4274d3260149717328.1272617852.git.ext-andriy.shevchenko@nokia.com>
	 <20100430120703.ffab0258.akpm@linux-foundation.org>
Date: Sun, 2 May 2010 21:12:11 +0300
Message-ID: <y2k5ec8ebd51005021112s2f511377ue9f3b15ef61a3894@mail.gmail.com>
Subject: Re: [PATCH 01/10] lib: introduce common method to convert hex digits
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 10:07 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> I had to fiddle with it:
> - use tolower(), saving 3 bytes!
> - test the more common case first - it's quicker.
Agreed in conjunction with comment from Joe Perches.
I'll resend new patch soon.


-- 
With Best Regards,
Andy Shevchenko
