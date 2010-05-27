Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab0E0E3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 00:29:45 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60185 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab0E0E3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 00:29:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=ULQ/E6BbKZCFNhaI2N/4F7g8jaQdocpq+RTMKLffccvEgu1F6FTmMjFDBH426whhA5
         nBQMBC+dEYBmTfNeOrXuycctb+cU8DCpKxK1E9Az5Hd+YTZym9iZVz8TUeSGmLR/dp/f
         FrXKOwppIyhBSwdaUkMgJ62msJch/7NNgTM0c=
MIME-Version: 1.0
In-Reply-To: <1268066071-26711-1-git-send-email-vapier@gentoo.org>
References: <1268066071-26711-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 27 May 2010 00:29:23 -0400
Message-ID: <AANLkTimaeOLsoh8bLXw1t8ElmvtARpRhgwbqyb5sViGI@mail.gmail.com>
Subject: Re: [PATCH] asm-generic/io.h: add big endian versions of 
	io{read,write}{16,32}
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 8, 2010 at 12:34, Mike Frysinger wrote:
> The asm-generic/iomap.h provides these functions already, but the
> non-generic fallback defines do not.

Andrew: could you pick this up ?
-mike
