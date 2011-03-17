Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab1CQH4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 03:56:51 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52873 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab1CQH4s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 03:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rNirkW+6V3TFSluOidyUUjgbGP7K8T8AdxLh8cmDqn0fFTRZMH6u2T8n7lQu8SxD8m
         53WwwBl2vQ3hrRZebOqZTYSBPA7rgLyDFk6FLmydU7m2Q59hX4jXYEG3YG2YusD9NQyM
         0Wa0Vgs03YNttqvmX4kfLEK/96P13SkIbPQsU=
MIME-Version: 1.0
In-Reply-To: <20110317074356.231320@gmx.net>
References: <20110317074356.231320@gmx.net>
Date: Thu, 17 Mar 2011 08:56:47 +0100
Message-ID: <AANLkTim2cggAu6o7iU74S47xyFfOqrSiUPOfo+2XoidB@mail.gmail.com>
Subject: Re: sctp panic
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: sctp@muskelshirt.de
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 8:43 AM,  <sctp@muskelshirt.de> wrote:
> Hi
>
> when doing the actions below I get a panic.
>
> - echo 1 > /proc/sys/net/sctp/addip_enable
> - In a C-Programm
>    - socket(AF_INET,SOCK_STREAM,IPPROTO_SCTP);
>    - connect(....)     (with correct filled parameters)
>
> Its no process (waiting in accept) neccessary

Can you show us the panic message and your C prorgam?
This would help reproducing the panic...

> br
> walter
> --
> GMX DSL Doppel-Flat ab 19,99 Euro/mtl.! Jetzt mit
> gratis Handy-Flat! http://portal.gmx.net/de/go/dsl
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Thanks,
//richard
