Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761333Ab0J0ONO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:13:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38544 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952Ab0J0ONL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:13:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=lE2i1qRv1RhRxwFQNjArq87har1hIHoNv95SJ+dUYFondRH1yN7qsMnp/xvuwxrEyB
         Ysd6dqK9Oo4iTpZBtWI7LcISpMBLryNE7VU9q9MuRE+zAAsGj7CJtIHqGtnkTLqBVRax
         Nki+/wL0OoF+MriXDO3bHTHqzw9eHX9FyR6ak=
MIME-Version: 1.0
In-Reply-To: <201010271555.21201.arnd@arndb.de>
References: <1288145006-31108-1-git-send-email-vapier@gentoo.org>
 <1288145006-31108-2-git-send-email-vapier@gentoo.org> <201010271555.21201.arnd@arndb.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 27 Oct 2010 10:12:50 -0400
X-Google-Sender-Auth: O3B8NgP0Y1ubcMRMVVaDwE6TR6Y
Message-ID: <AANLkTi=RdaedGVG8=G9Cth7eLZpiSB9BXUPPSfggWdFN@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH 2/2] asm-generic/io.h: add
 reads[bwl]/writes[bwl] helpers
To: Arnd Bergmann <arnd@arndb.de>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 09:55, Arnd Bergmann wrote:
> On Wednesday 27 October 2010, Mike Frysinger wrote:
>> A bunch of arches define reads[bwl]/writes[bwl] helpers for accessing
>> memory mapped registers.  Since the Blackfin ones aren't specific to
>> Blackfin code, move them to the common asm-generic/io.h for people.
>
> Just keep it in your series to make it clear where it comes from.
> I'd put it before the other one though.

OK, will do.  thanks !
-mike
