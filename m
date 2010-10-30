Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0J3QqG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 12:46:06 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58197 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab0J3QqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 12:46:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AtbJ2gKU2Y3rwzgMNWsxqZWkuDtQQ09HHFTPvA2TVtGoahYCPQyjDLbv2H6ZCfmvFw
         P+Us/pg0DZ1i+Wa2ukrGRCjFKyMw0g490GaxqPx8pUQRvKYGQ/xixT8Zv+B65aw7mZmr
         ciEa9+7jlZJ0ASgZacWb+CCrOkwsvBHLaPKQg=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1010301818320.1572@swampdragon.chaosbits.net>
References: <AANLkTi=ZTOyrNQO+-tbTBAqpHcUknxWqZ8i6cimagjjm@mail.gmail.com>
	<alpine.LNX.2.00.1010301818320.1572@swampdragon.chaosbits.net>
Date: Sat, 30 Oct 2010 12:46:03 -0400
Message-ID: <AANLkTim=c-vuuxc9v2KvOxtzjm_FqKYwNKBNe2OfEefQ@mail.gmail.com>
Subject: Re: Just wondering
From: Tracey Dent <tdent48227@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/10, Jesper Juhl <jj@chaosbits.net> wrote:
> On Sat, 30 Oct 2010, Tracey Dent wrote:
>
>> How can u get an repository at git.kernel.org for linux kernel
>> development??
>
> This will clone Linus' tree into a local directory named 'linux-2.6' :
>
> $ git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> linux-2.6
>
> To update the tree you can :
>
> $ cd linux-2.6
>
> $ git pull
>
> You can do the same for other trees.


I know how to clone. I was wondering how to get your own repository?
> Consider reading this: http://linux.yyz.us/git-howto.html
>
>
> --
> Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
> Plain text mails only, please      http://www.expita.com/nomime.html
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
>
>
