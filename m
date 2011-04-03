Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab1DCAIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 20:08:18 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:32922 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab1DCAIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 20:08:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WrEjb6g4+GpePPoRhGoP6TQO+Z785lY/pp6VYSg5FbgFGNNg0RKV0230u/UXrb6Kmf
         TlOoqUk2riW4dFPxKNJcbZbpcTm6iLV8GAaowSnJH0ZHE11N2jhcMt9VzGd+ca8efnik
         LnZmJLZXPnZiaj6HVkZ83XbTRfG7UehMR1+Js=
MIME-Version: 1.0
In-Reply-To: <20110402222118.3b5c2fa8@holly>
References: <20110402222118.3b5c2fa8@holly>
Date: Sun, 3 Apr 2011 03:08:14 +0300
Message-ID: <BANLkTi=Y-+7i-4aeqHmk9WKDSqyDbGTduQ@mail.gmail.com>
Subject: Re: 2.6.39-rc1 data corruption with rtorrent
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Jindrich Makovicka <makovick@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 2, 2011 at 11:21 PM, Jindrich Makovicka <makovick@gmail.com> wrote:
> Hi,
>
> I hit an rtorrent data corruption issue again. But this time, rtorrent
> seems to write data that were mmapped by other processes (in the
> downloaded files, I found my data from Chromium and later the data
> produced by the testing utility by Linus from
> http://lkml.org/lkml/2006/12/27/180). Unfortunately, I was so far
> unable to reproduce the issue just with the testing utility.
>
> I reverted to stable 2.6.38.2 for now as I don't feel like broadcasting
> my private data via bittorrent.
>
> Regards,
> --
> Jindrich Makovicka
>

Do you have an r8169 also ?
I have data coruption in my torent files. But I didn't think to blame
the kernel for that.
