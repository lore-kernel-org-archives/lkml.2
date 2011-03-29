Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab1C2I6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 04:58:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55365 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab1C2I6g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 04:58:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nsDN6idnpRnCiZNT2Xma7uh93Ez7hsG1doLnHauK29Q+dVqz0ex4c+KvM9y9NyTC+Z
         An+tp6kTRalcqJK544Fiy0ATfHqtXSeHJkhYLBHqyOFxxElgU1SPTUveJLU2FAtK09T1
         7RqLOGH8aD2KwVPcZX1ebvbK9wS8VaGLn62zw=
MIME-Version: 1.0
In-Reply-To: <20110329055434.GA10227@verge.net.au>
References: <1301085148-14860-1-git-send-email-vapier@gentoo.org>
	<20110329055434.GA10227@verge.net.au>
Date: Tue, 29 Mar 2011 16:58:34 +0800
Message-ID: <AANLkTimX2yxx5QaDnXeF9vPRLSGW0-oNocj2c3ST-OQG@mail.gmail.com>
Subject: Re: [PATCH] NOMMU: implement access_remote_vm
From: Wan ZongShun <mcuos.com@gmail.com>
To: Simon Horman <horms@verge.net.au>
Cc: Mike Frysinger <vapier@gentoo.org>, uclinux-dev@uclinux.org,
        David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@uclinux.org>,
        Paul Mundt <lethal@linux-sh.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/29 Simon Horman <horms@verge.net.au>:
> On Fri, Mar 25, 2011 at 04:32:28PM -0400, Mike Frysinger wrote:
>> Recent vm changes brought in a new function which the core procfs code
>> utilizes.  So implement it for nommu systems too to avoid link failures.
>>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>
> This resolves a build problem that I observed this afternoon.

oh, I just find this build error about access_remote_vm, this patch
will fix my issue.

thanks!

>
> Drive-by Tested-by: Simon Horman <horms@verge.net.au>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
*linux-arm-kernel mailing list
mail addr:linux-arm-kernel@lists.infradead.org
you can subscribe by:
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

* linux-arm-NUC900 mailing list
mail addr:NUC900@googlegroups.com
main web: https://groups.google.com/group/NUC900
you can subscribe it by sending me mail:
mcuos.com@gmail.com
