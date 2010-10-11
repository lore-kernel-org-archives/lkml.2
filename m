Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab0JKJRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 05:17:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50134 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab0JKJRk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 05:17:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mLpOPfprup5h+W44zqAdP6HrX90sBSzWLiSBeIWFbjyaHUcsjI9DQJGMJ1lGpCK5Vc
         aJTeG9jH5Umr5C5KbR5CpMBfp18yj0oX71U/+haRII51u/hVTdYxMzSxoyHwwYUU5wlO
         ZfojPfPzx5wxHC0dz017yUD/jnPaYr2MDgM+g=
MIME-Version: 1.0
In-Reply-To: <20101010124159.GA21776@kroah.com>
References: <86dfcd5dfdee8ce5ca558634d4606922f05e96e1.1286705921.git.andy.shevchenko@gmail.com>
	<20101010124159.GA21776@kroah.com>
Date: Mon, 11 Oct 2010 12:17:38 +0300
Message-ID: <AANLkTimLeeZ5QpFE9my5fyPpg63t+VKcOTHtS7S5FdQU@mail.gmail.com>
Subject: Re: [PATCH 1/3] staging: brcm80211: clean up custom ctype library again
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Nohee Ko <noheek@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 3:41 PM, Greg KH <greg@kroah.com> wrote:
> This file is now gone from the tree, as of yesterday.  Care to resync on
> the next linux-next tree on Monday and verify if any of these patches
> are even needed anymore?
Done! Still some clean ups are needed. Already sent new patch series.

-- 
With Best Regards,
Andy Shevchenko
