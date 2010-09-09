Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab0IIXnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 19:43:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40259 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab0IIXnY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 19:43:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ddm6nyhGZeaOVPtPr8InhZgaxhipNGTHBx8qxEy/lrM66yNfLKHuyUtT7ozblrzngt
         T2bJ74/9RkMIaGKQ+pSbHddIw+CjmJuhf1IxpjQoiZ3vumob39rPoZ8tSpMxTTuU0wD/
         iWLcLhbajFbV18aA0JXs/Sf1TgFBQek6xyjGs=
MIME-Version: 1.0
In-Reply-To: <4C895028.3010609@zytor.com>
References: <1283563039-3466-1-git-send-email-brgerst@gmail.com>
	<1283563039-3466-8-git-send-email-brgerst@gmail.com>
	<4C895028.3010609@zytor.com>
Date: Thu, 9 Sep 2010 19:43:22 -0400
Message-ID: <AANLkTim17SC==8Tm6=vMwRa6_ddpo2VcVjQqJAen7bHW@mail.gmail.com>
Subject: Re: [PATCH 07/12] x86-64: Simplify constraints for fxsave/fxtstor
From: Brian Gerst <brgerst@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, penberg@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 9, 2010 at 5:22 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 09/03/2010 06:17 PM, Brian Gerst wrote:
>> Use the "R" constraint (legacy register) instead of listing all the
>> possible registers.  Clean up the comments as well.
>>
>> Signed-off-by: Brian Gerst <brgerst@gmail.com>
>
> Hi Brian,
>
> Have you tested this on *old* versions of gcc?  Since the whole point of
> that butt-ugly code sequence is to support now-historic versions of
> binutils, we need to make sure that "R" was supposed on the
> corresponding gcc versions...

It's documented as far back as the GCC 3.1.1 manual.  Whether it
actually works or not on older compilers I have no way of testing.

--
Brian Gerst
