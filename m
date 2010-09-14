Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab0INAL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 20:11:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44256 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab0INALz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 20:11:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A8oszfKRP1J1mW8qRGeu8Jp3UNFTt2YnWNBTVyU5We8TW6pDjYeohm5zN9wZTjsAzu
         47rHaeC8YZQgS9Q+aKXCYQ7kBRakxgbqmpINyN4tCADgYL6+po8QBGPhkPnU9vcIp2BF
         /G08lb2LutwMnX11LkX3BlPEoMir0zu8q2+DI=
MIME-Version: 1.0
In-Reply-To: <1284408880-14414-1-git-send-email-hpa@linux.intel.com>
References: <1284408880-14414-1-git-send-email-hpa@linux.intel.com>
Date: Mon, 13 Sep 2010 20:11:53 -0400
Message-ID: <AANLkTi=JpfhvyxC13U98x5me9U8dU6BHOcGkPC0KK7aW@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Bump gcc minimum version to 3.4, 4.1 for x86
From: Brian Gerst <brgerst@gmail.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 4:14 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> This patchset bumps the minimum supported gcc version to 3.4 for the
> general kernel, and to 4.1 for x86.
>
> We have had a rash of bug reports related to these really old
> compilers and their associated binutils version lately, and it is
> clear that the support burden of these older compilers is getting to
> be excessive.  If you really want to build a kernel on a system that
> old you can build or obtain an updated gcc/binutils as well.

What version of binutils does this correspond to?  It would be nice to
clean up some of the hacks for ancient binutils as well.

--
Brian Gerst
