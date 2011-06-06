Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab1FFQ6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:58:37 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:36583 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab1FFQ6d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:58:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Ifb/isGUDDoJ9EeOdsDYqmKZuYEuHddbuk8HwqvR99TSQ9fsSeSew+DJ9aR/ZoPMYS
         SAwCLFeeS1el/BP0wVQ4Fu24JUzRJ77wdd1t9rceRXe3bk8NakNypYKmKV6gOX2FbGdb
         zNUMhpAautbb4hh5xD8s/2JWWLcYoiwGX+LoA=
MIME-Version: 1.0
In-Reply-To: <51E1844698%linux@youmustbejoking.demon.co.uk>
References: <51E1844698%linux@youmustbejoking.demon.co.uk>
Date: Mon, 6 Jun 2011 11:58:33 -0500
Message-ID: <BANLkTimRFJoo3rrU7fLriu1L-xt5MCmymQ@mail.gmail.com>
Subject: Re: [3.0-rc1] CIFS ACL build failure without CONFIG_KEYS
From: Steve French <smfrench@gmail.com>
To: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Darren Salt <linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I merged the 2nd of the two.

On Tue, May 31, 2011 at 12:23 PM, Darren Salt
<linux@youmustbejoking.demon.co.uk> wrote:
> In 3.0-rc1, without CONFIG_KEYS, cifs-acl.c compilation fails with various
> errors, including one about trying to dereference an incomplete type (struct
> keys, defined in <linux/key.h>).
>
> I'm including two patches for this since I don't know which way to go on this
> one: pick whichever is more correct :-)
>
> --
> | Darren Salt  | linux or ds at  | nr. Ashington, |  _  ASCII ribbon
> | using Debian | youmustbejoking | Northumberland | ( ) campaign against
> | GNU/Linux    | ,demon,co,uk    |                |  X  HTML e-mail
>                                                    / \ www.asciiribbon.org
> Live every day like it's your last, because one day you'll be right.
>
>



-- 
Thanks,

Steve
