Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab0JQIZV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 04:25:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60494 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab0JQIZR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 04:25:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=msD91TtWEe0fWcmN1Cjq4MVn6euY8jn5BWP5gatzfMxdmRdZoDFOtOuJ+xHdV6Nvv2
         CDQyhc6Prd30bpyMKcutB2Vuqx5JootJORt3nan9hRCgXGt0Yq/P5N6PXw/rmoM1Djul
         RHXTRXGvWfonApr0RjSpHnSGIimiJV1rXXA98=
MIME-Version: 1.0
In-Reply-To: <1287303678.20968.37.camel@Joe-Laptop>
References: <1287302737-3507-1-git-send-email-vapier@gentoo.org> <1287303678.20968.37.camel@Joe-Laptop>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sun, 17 Oct 2010 04:24:54 -0400
X-Google-Sender-Auth: 4k0QH9PL-3QQ8IbVYhjRTTjPHLo
Message-ID: <AANLkTimmSRS3eVsW4EZUxnE_rfjeqmmgGnjtWbn3J_nY@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: allow single space before labels
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 04:21, Joe Perches wrote:
> On Sun, 2010-10-17 at 04:05 -0400, Mike Frysinger wrote:
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
>>  # check for spaces at the beginning of a line.
>> -             if ($rawline =~ /^\+ / && $rawline !~ /\+ +\*/)  {
>> +             if ($rawline =~ /^\+ / && $rawline !~ /\+ +\*/ && $rawline !~ /:$/)  {
>
> Perhaps that's not an ideal test.
> Maybe "&& $rawline !~ /^\+ \w+:/" is better.
>
> The current test misidentify labels with comments:

i know, but i didnt want to dive further down this rabbit hole.  most
labels do not have trailing comments, or at least all the ones i deal
with.

feel free to extend however as long as the end result is no warnings
for " foo:" ;).
-mike
