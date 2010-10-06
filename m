Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab0JFJZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:25:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32907 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab0JFJZN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:25:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IHX+Br78eqDqPhM2cC3F2pdqF8252V/EXTjAi1ZO0Imv+1Cpa2/HtYjgsGMab3pRvd
         wYDwJ/LKnAcJ+wiW9ejNw2GbsrygHMlVjaRW5FTST2ZEqYzNtD9al4v+d0ILa0WWQioM
         xLR+gC/JOIPisyS3GWOWbvmtSjGv+/cclqvVc=
MIME-Version: 1.0
In-Reply-To: <12E01E63-75E5-4822-BEA6-D8C0260BC915@mac.com>
References: <12E01E63-75E5-4822-BEA6-D8C0260BC915@mac.com>
Date: Wed, 6 Oct 2010 12:25:12 +0300
X-Google-Sender-Auth: DULxciJkKA_PzjG-NuI6vq3h9tI
Message-ID: <AANLkTimqfHEYyErLiWfrW5SkjseTvcswoPOP2Jkab1pC@mail.gmail.com>
Subject: Re: How to test kernel drivers for memory leaks
From: Pekka Enberg <penberg@kernel.org>
To: Elvis Dowson <elvis.dowson@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 6, 2010 at 11:13 AM, Elvis Dowson <elvis.dowson@mac.com> wrote:
>       I would like to analyze the driver sources for a Ralink RT3070STA USB wifi module for memory leaks, using linux kernel 2.6.32, running on a TI OMAP 3503 platform target.
>
> Which tool (open-source or commercial) is best suited for this task?

Kmemleak is an in-kernel memory leak detector. See
Documentation/kmemleak.txt for details.
