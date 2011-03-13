Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab1CMWph (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 18:45:37 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59705 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab1CMWpe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 18:45:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=n9Kt1n7Rs/uSemUzjz0Cm4EUHySeuZUl2Fe3KiVluNxbZheocxZVAJ2C6quiMyb5Pr
         25aioDj+/vhceIO8ligs7qoiEKAlabYjq3Xm/4GUqIRpou6Pq/mZD1rD5dRyrkzNu1Fk
         GIvfl/YyX4B18dgS4c7ztvY6VDu0V/Q2LAbz0=
MIME-Version: 1.0
In-Reply-To: <AANLkTiko9Y6z79XwkxN7dEAyikQbO=Azdiu0hhK+uiJc@mail.gmail.com>
References: <1300033426-22404-1-git-send-email-richard.genoud@gmail.com> <AANLkTiko9Y6z79XwkxN7dEAyikQbO=Azdiu0hhK+uiJc@mail.gmail.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Sun, 13 Mar 2011 23:45:17 +0100
Message-ID: <AANLkTikJVqk7UO6Be1A12SRp62z0h7rjEdhUa-uMYH2t@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=5BPATCH=5D_cifssmb=3A_=5BFIX=5D_warning=3A_=E2=80=98pdata=E2=80=99_may_?=
	=?UTF-8?Q?be_used_uninitialized?=
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/13 Steve French <smfrench@gmail.com>:
> This does look a problem with the compiler.  Which compiler version?
>
> As you noted, pdata is either initialized or we return rc!=0 and don't use it.
>
The compiler is gcc from ubuntu 10.10 :
gcc (Ubuntu/Linaro 4.4.4-14ubuntu5) 4.4.5
