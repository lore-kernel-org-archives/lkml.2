Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab0DVVoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 17:44:10 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:57660 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab0DVVoH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 17:44:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l+OUULxNlAFsPnEtpqSpN/iAfGGDZdAMK3k0xWs/kZSdG0myMR9VcriMhzNNMKETNP
         JWrBL6afpfB9Pp13/iI6xiTQIDm8TT3ZMfGQ0WN6c9uzJQSsfwNXbuT6u0i57qQ10wWp
         qXXD+iH9UY2XZ98MKVq9EMHqkYqNxDYU1zr1o=
MIME-Version: 1.0
In-Reply-To: <p2v8bd0f97a1004221421x4bf0850fm1b47f4838c344368@mail.gmail.com>
References: <1271970765-11856-1-git-send-email-fgaliegue@gmail.com>
	 <p2v8bd0f97a1004221421x4bf0850fm1b47f4838c344368@mail.gmail.com>
Date: Thu, 22 Apr 2010 23:44:05 +0200
Message-ID: <y2lac542ca01004221444le9b33c8as587d3382ab7ff0a9@mail.gmail.com>
Subject: Re: Should I really bother all maintainers with this?
From: Francis Galiegue <fgaliegue@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cc:ed trivial@kernel.org]

On Thu, Apr 22, 2010 at 11:21 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Thu, Apr 22, 2010 at 17:12, Francis Galiegue wrote:
>> This patch only fixes quite a common mistake in Documentation/, and if I
>> scripts/get_maintainer.pl on the patch (which is recommended), I potentially
>> mail thousands of people who probably have more useful/exciting stuff to do
>> anyway. So, I submit it as is.
>
> this kind of stuff usually goes through the trivial tree.  look at
> TRIVIAL PATCHES in the MAINTAINERS file.
> -mike
>

Point taken... But the patch doesn't apply as is over trivial/master or
trivial/for-next, as two files don't seem to exist on either branch (trivial
being the git repository mentioned in MAINTAINERS):
Documentation/DMA-API-HOWTO.txt and Documentation/filesystems/ceph.txt.

Thanks for the input,
-- 
Francis Galiegue, fgaliegue@gmail.com
"It seems obvious [...] that at least some 'business intelligence'
tools invest so much intelligence on the business side that they have
nothing left for generating SQL queries" (Stéphane Faroult, in "The
Art of SQL", ISBN 0-596-00894-5)
