Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab0KKPrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 10:47:09 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45354 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab0KKPrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:47:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mYGlDsvPiPQ0t8M15SWR6mWeXLlRJIjGsSBsmUfVjC3S8uF8hC+hT1bvw6rw6/UaUB
         uNhmN6CfPPMcDeZmqEz67rccWyqcVG4WxfMxFgdpFydIXwILyWwAm3rexpUY0HhAkYcN
         Q/07wEgZrPjX2LCyRnJcoJSOyfSKpRZ0FqnD8=
MIME-Version: 1.0
In-Reply-To: <20101111140932.GB21803@aftab>
References: <1289141013-1399-1-git-send-email-tdent48227@gmail.com>
	<20101111140932.GB21803@aftab>
Date: Thu, 11 Nov 2010 10:47:07 -0500
Message-ID: <AANLkTinPg-JkHcZFWKxF=JieFs6zo0fExRNA-YnK+=F8@mail.gmail.com>
Subject: Re: [PATCH] Drivers: edac: Makfile: Cleaned up Makefile
From: Tracey Dent <tdent48227@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "mchehab@redhat.com" <mchehab@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/10, Borislav Petkov <bp@amd64.org> wrote:
> On Sun, Nov 07, 2010 at 09:43:33AM -0500, Tracey Dent wrote:
>> Changed Makefile to use <modules>-y instead of <modules>-objs because
>> -objs is
>> deprecated and should now be switched. According to
>> (documentation/kbuild/makefiles.txt).
>>
>> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
>
> Applied, thanks.
>
 thanks


td
