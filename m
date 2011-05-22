Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab1EVUNV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 16:13:21 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64079 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab1EVUNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 16:13:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=k4nDHzf+a/eRjBSE31j+aOYB1bNOE691tqz2ZFOstwkRRVPvG7slALQMVA4uXZzHF/
         f7oVVJvvHvH2VnwvOJhQls+1pckJfrbIGftGUplGBExFIAyiDXQPV4IUn4CvnSMoJqxK
         G4Xm5ujZ6nuGUhwy5A/pyD+1q9XifjkPgfJZg=
MIME-Version: 1.0
In-Reply-To: <BANLkTinRJ12Jc4u1OpB67cc3T3Trhci3dw@mail.gmail.com>
References: <1306092879.16902.1.camel@monotop>
	<BANLkTin6=3rpchVFHi9P=6Cp31uL=vMM0w@mail.gmail.com>
	<BANLkTinRJ12Jc4u1OpB67cc3T3Trhci3dw@mail.gmail.com>
Date: Sun, 22 May 2011 22:13:13 +0200
Message-ID: <BANLkTimWZx+2BdtzVQfKk+fPAJ8eHRwF9Q@mail.gmail.com>
Subject: Re: [PATCH] fs: add missing prefetch header to inode.c
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Eduardo Silva <edsiper@gmail.com>
Cc: sedat.dilek@gmail.com, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 22, 2011 at 10:08 PM, Eduardo Silva <edsiper@gmail.com> wrote:
> oh, yep, it was in UM arch :)

I've already submitted a patch for UML.
fs/inode.c is not the only place which needs the prefetch stuff...

-- 
Thanks,
//richard
