Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab1CCNsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 08:48:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44932 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab1CCNsC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 08:48:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kazW4iv5pLviawdC605Z5uGchwPCzUPnAU8Sdv8vb4PxmN20XCCz44Oi/eHNIJSXSG
         KccyyL6k+8n/D6mo4TnxxLbrS/aHoNYxnNb772bibZSf7DIMVFKITdQtHsvMTcSdKPep
         lNk0fwEIQuf9hrd3hZwe3i3+OFeKjAwfgnrzE=
MIME-Version: 1.0
In-Reply-To: <AANLkTimqT82wR20vvunnMvNShFSs0zWtmeT66A84Nh5t@mail.gmail.com>
References: <AANLkTimqT82wR20vvunnMvNShFSs0zWtmeT66A84Nh5t@mail.gmail.com>
Date: Thu, 3 Mar 2011 05:48:01 -0800
Message-ID: <AANLkTi=m_qO0=o81+Db_B-kt1DWP-Af6So+_LiZMgONF@mail.gmail.com>
Subject: Re: [BUG] as of trunk build Linux kernel trunk entry_32.S got error
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Hui Zhu <teawater@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: binutils@sourceware.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 10:16 PM, Hui Zhu <teawater@gmail.com> wrote:
> as -version
> GNU assembler (GNU Binutils) 2.21.51.20110303
>  AS      arch/x86/kernel/entry_32.o
> /home/teawater/big/kernel/linux-2.6/arch/x86/kernel/entry_32.S:
> Assembler messages:
> /home/teawater/big/kernel/linux-2.6/arch/x86/kernel/entry_32.S:1422:
> Error: .size expression does not evaluate to a constant
>
> When I change back to the as of system, everything is OK.
>
> Because I always use the as of trunk, so I think a recent PATCH caused
> the problem.
>

You need

http://git.kernel.org/?p=linux/kernel/git/hjl/linux-2.6.37.y.git;a=commitdiff;h=2c5ce9c1b8eb927c131a31d4466e24e00647e9cb


-- 
H.J.
