Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab0KAKR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 06:17:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64796 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098Ab0KAKRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 06:17:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VrVzJ5tN4S1xaoCGKO7kiu/gkGaki+k8SUKVHBR77Nxt3Y5fS5DvSZYMvL9pmBCffp
         GChqTZMEQRZ3rAekeL73OPGnPVgnLwGOO9Rmmx2spD30dwniI/4qpZdKdhFsRML24uR5
         nJd591CfWGEbxqu6s3kqsilMgwbaSB7W626SU=
Message-ID: <4CCE93B1.90801@gmail.com>
Date: Mon, 01 Nov 2010 03:17:21 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ramya Desai <ramya.desai@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Where can I find -rc kernels?
References: <AANLkTimE4QR+=eXfSMQ5s3OvnLU0Z=7uR1vtokpLnj7X@mail.gmail.com>
In-Reply-To: <AANLkTimE4QR+=eXfSMQ5s3OvnLU0Z=7uR1vtokpLnj7X@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2010 03:01 AM, Ramya Desai wrote:
> Dear All,
>
> Generally, I download the stable kernels from
> http://www.kernel.org/pub/linux/kernel/v2.6/ However, I did not find a
> link, like this, for -rc kernels. Please let me know, from where can I
> download the -rc kernels. Please provide a link to me.
>
> Thanks and Regards,
> Ramya.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


why not just do a git clone of linus's tree then do a git reset --hard 
v2.6*(some rc version you need...)

this way you do not need to depend on kernel.org providing you the kernel...

(as for the site..no idea what happened there..)

Justin P. Mattock
