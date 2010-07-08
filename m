Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab0GHQbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 12:31:40 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33055 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab0GHQbj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 12:31:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ngWtciliKC8er0MVmBdjrpH3zhwyjw1WjiWKuQ+wEnd4gAWQ4ijvfFu6WrMbBo2qwN
         9dkFKMa4Z/mQmHfrrlmJIYQTt2LbGd4ak3VsIsoygeidQ4dTzkgybPu87VevCgPm+8m/
         3NjCtz2eRI5x/NL9SIiCBQJtHDmA6AW4SLmiU=
MIME-Version: 1.0
In-Reply-To: <20100707004841.GA28188@verge.net.au>
References: <1278435198.5396.73.camel@dermezel>
	<AANLkTingSXbyFclWga9x5aD7MoccCMqhu56PCOVTKHVJ@mail.gmail.com>
	<20100707004841.GA28188@verge.net.au>
Date: Thu, 8 Jul 2010 11:31:37 -0500
Message-ID: <AANLkTink0wl6OcOf0fWO87q6-3qS2R3e_cQ2bclRpGg-@mail.gmail.com>
Subject: Re: [PATCH] Staging: dt3155: fix coding style issues in dt3155_drv.c
From: Aldo Cedillo <aldobrett11@gmail.com>
To: Simon Horman <horms@verge.net.au>
Cc: kagen101@gmail.com, Greg Kroah-Hartman <gregkh@suse.de>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       devel <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I believe that you will find both of the following styles in abundance
> and that both are acceptable.
>
>   /*
>    * This
>    * is a multi-line comment
>    */
>
> And
>
>   /* This
>    * is a also multi-line comment
>    */
>
> Though one may be more acceptable to a given maintainer than the other.
> Other variants may also be common and acceptable to some maintainers,
> which I suspect is why checkpatch.pl is lenient.

:S , so I believe both are correct... as you stated this doesn't help
to make a single
tool to check. Well thanks for the comment.

Aldo Brett
