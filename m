Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab1FGJtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 05:49:01 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42156 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab1FGJs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:48:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=e+fs4PH6jSjKxPZzGi2yCQuJetqP2/UWDTEugo9o+85l7yRUV1afIrPWP1RHtbsKrL
         gWoXJRWUeGbof/lwOANaHxCX85MA/EohIryWvNBWG/il9zj/EsjFnx38RpUqD1sXXabc
         +zixL6LPO5IRa4IQ/bSB1DoSLHOgjWxmFke5M=
MIME-Version: 1.0
In-Reply-To: <20110606132036.aebd73a4.sfr@canb.auug.org.au>
References: <20110606132036.aebd73a4.sfr@canb.auug.org.au>
Date: Tue, 7 Jun 2011 10:48:57 +0100
X-Google-Sender-Auth: VJCqjCgQXoutz4PrL73po4zGQAM
Message-ID: <BANLkTikAq6D6RjBhxsNva7KhYRh6=UfcKw@mail.gmail.com>
Subject: Re: linux-next: Tree for June 6
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 June 2011 04:20, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Changes since 20110603:
>
> New tree: arm-lpae

This introduced a few build failures on some ARM platforms (missing a
types.h include). I fixed up the pgtable files and the builds should
be ok in 20110607.

-- 
Catalin
