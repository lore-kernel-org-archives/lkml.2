Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab0KVE7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 23:59:18 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64036 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab0KVE7R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 23:59:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AC8czpRHSG49qZf5zRGrZhk13jgCPYKLChx4KLDpnrPv5X3vKXGyVEeWsQO4GkrbhU
         SB9RIni5PAxZXPWiXW7O1KPj2TVXld4LMb9/SM16KGJNS6wZEgka55a/rX4mxOg6av9G
         OSbU3Zlp2J5ryQBSNEPvzPDlh9EbiFTegJqFQ=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1011210819350.25385@localhost6.localdomain6>
References: <alpine.DEB.2.00.1011210819350.25385@localhost6.localdomain6>
Date: Mon, 22 Nov 2010 10:59:15 +0600
Message-ID: <AANLkTi=yqvo_uRfSxEu-YZrGQcEu9r4m2kFXHptshFXk@mail.gmail.com>
Subject: Re: [PATCH] Change return type of obvious Boolean list fns to "bool".
From: Rakib Mullick <rakib.mullick@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 7:35 PM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
>
>  Compile-tested with defconfig on x86_64.  Not sure who should
> be CCed when a patch touches something this basic.  Andrew?
>
You can use scripts/get_maintainer.pl to find out who should be cc'ed.



thanks,
rakib
