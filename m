Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0HZCHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 22:07:13 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50296 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab0HZCHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 22:07:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=HeYayWhHam2elIHhhsCj2J3R3w8MLI4fcP6rxZAEj+fPTzT99kZx7HCXbCndkss3V7
         hdWKM6p50VvM8HYUyThm1dom6fUJ0R4RUNn3VJQBlkfE3Ol72EmdWMUKxUahJt8xHDtI
         zY4geacpdeSVF/RzkgWTp2UNxVvqH59fPgZjw=
MIME-Version: 1.0
In-Reply-To: <20100826110229.931ab5bf.sfr@canb.auug.org.au>
References: <20100826110229.931ab5bf.sfr@canb.auug.org.au>
Date: Wed, 25 Aug 2010 21:07:08 -0500
Message-ID: <AANLkTikvKchHEFR_F-Fdo6Z8n2XKbi4tRh0eYnjzVQJ9@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the cifs tree
From: Steve French <smfrench@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 8:02 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
>
> fs/cifs/sess.c: In function 'CIFS_SessSetup':
> fs/cifs/sess.c:623: warning: unused variable 'ntlmsspblob'
>
> Introduced by commit 9fbc590860e75785bdaf8b83e48fabfe4d4f7d58 ("[CIFS]
> Fix ntlmv2 auth with ntlmssp").

Shirish's patch doesn't use that local variable when experimental is
off - I will talk to him about simply moving the local variable to
eliminate the unused variable warning.


-- 
Thanks,

Steve
