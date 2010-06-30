Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab0F3VB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 17:01:28 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53141 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab0F3VB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 17:01:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=UcKGhJIXCTTcSvBWwGwLUefPONGygVPsUnTt4nDSl4udB8JKMyi0EghzzgNXUyq4Dz
         UCxzZAyxzjvjgsgPS3kzPhSsWG2PRG66pC1OA68RJ5YVOjt55/yOz/yfTqXBVvRSq2fV
         QNcKACYHSjkIZ7Uq7ZEW9bEGI5tTKdz++N2UA=
MIME-Version: 1.0
In-Reply-To: <AANLkTine3pc2Ai2Woj81Y9fS_KgGs1sIMb2NMR6G74ww@mail.gmail.com>
References: <20100308191005.GE4324@amak.tundra.com> <AANLkTine3pc2Ai2Woj81Y9fS_KgGs1sIMb2NMR6G74ww@mail.gmail.com>
From: Timur Tabi <timur.tabi@gmail.com>
Date: Wed, 30 Jun 2010 16:00:56 -0500
Message-ID: <AANLkTinKbimKyLpvFD7KOvavshu_n8gRcp2BvEJj0XZQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] powerpc/85xx: Add MChk handler for SRIO port
To: Alexandre Bounine <abounine@tundra.com>
Cc: mporter@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, thomas.moll@sysgo.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 3:55 PM, Timur Tabi <timur.tabi@gmail.com> wrote:

> MCSR_MASK is not defined anywhere, so when I compile this code, I get this:

Never mind.  I see that it's been fixed already, and that the patch
that removed MCSR_MASK was posted around the same time that this patch
was posted.


-- 
Timur Tabi
Linux kernel developer at Freescale
