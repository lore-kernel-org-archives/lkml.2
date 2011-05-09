Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313Ab1EIJew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 05:34:52 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49823 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1EIJev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 05:34:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=bybIaq+oDZF/FGKGDeIMWvCRqKwysiz7yrBr0VynGRqRXCMyZCwmPCSl73VSlNCux2
         7/jkxBYKxesRALm4zfsl+4n8kbtx4xUIYRAwVqAvlhegSntnMlk1/ibDqKms5eVDZSw4
         XOOTqnBbfL/k5SZo+OPsz2AhIxcaPMWFzDk5w=
MIME-Version: 1.0
In-Reply-To: <20110509145854.9e6d8806.sfr@canb.auug.org.au>
References: <20110509145854.9e6d8806.sfr@canb.auug.org.au>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 9 May 2011 11:34:35 +0200
Message-ID: <BANLkTinzFs0cfGdmkdOE8cgKSHK=5NEjmg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (driver-core tree related)
To: Stephen Rothwell <sfr@canb.auug.org.au>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Anton Guda <atu@dmeti.dp.ua>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 9, 2011 at 06:58, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> After merging the final tree, today's linux-next build (powerpc allnoconfig)
> failed like this:
>
> kernel/sys.c: In function 'kernel_restart_prepare':
> kernel/sys.c:317: error: implicit declaration of function 'usermodehelper_disable'

Rafael, seems usermodehelper_disable() depends on CONFIG_PM_SLEEP.

Any reason for that conditional? Remove it now?

Thanks,
Kay
