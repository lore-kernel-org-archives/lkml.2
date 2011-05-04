Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1EDKZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 06:25:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62708 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab1EDKZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 06:25:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qeRBDxLhGPGyNlnLac/LMItr9xE3bKV0+z+WWQau1oFC755jcyPQDaTw1TkzjYfX+J
         op30wULfsWA0WVqeKBpoMBALEP/k1519QjF0ZZlIxuZH9xT9BkoMssRzmpxm+JWEuViX
         b/lRP4GW9Bzw8gbnbhKaG59ivHA1pHXSMyil4=
MIME-Version: 1.0
In-Reply-To: <BANLkTimLd-qY-OeKqnf2EoTfvAHWQZVchw@mail.gmail.com>
References: <BANLkTimLd-qY-OeKqnf2EoTfvAHWQZVchw@mail.gmail.com>
Date: Wed, 4 May 2011 11:25:45 +0100
X-Google-Sender-Auth: 5HhoiduKCNGeHd8GpWd9X6yo5Bc
Message-ID: <BANLkTi=xz4w3p4bc5T4-YvkC3tYdwKhWGA@mail.gmail.com>
Subject: Re: [ARM]crash on 2.6.35.11
From: Catalin Marinas <catalin.marinas@arm.com>
To: naveen yadav <yad.naveen@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>, linux-arm-request@lists.arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 May 2011 11:09, naveen yadav <yad.naveen@gmail.com> wrote:
> We are running linux kernel 2.6.35.11 on Cortex a-8. when I run a
> simple program expect to give oom.
>  But it crash with following crash log

Could you post the full kernel boot log and .config file?

-- 
Catalin
