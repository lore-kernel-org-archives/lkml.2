Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab0ETKpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 06:45:11 -0400
Received: from mail-qy0-f171.google.com ([209.85.221.171]:34891 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab0ETKpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 06:45:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=imGNm+Vb1rc4uWfBGmvG1ERSis86h8gc1f3RuFoir5LlcxN8S1vJ9mnrosOb1QGO5H
         PQrtqjCa23gSpIdMeEPiMfAthf8LDhPBPgZ71ZutHqcUjlJYXcMseI1Si+jnhIMlDpak
         EnYlXJIAXfh8wLlQAplfDLWpqLsQEU9KTjSb8=
MIME-Version: 1.0
In-Reply-To: <1274097901.1705.575.camel@Joe-Laptop.home>
References: <1274093311-6309-1-git-send-email-reodge@gmail.com>
	 <1274097901.1705.575.camel@Joe-Laptop.home>
Date: Thu, 20 May 2010 18:45:08 +0800
Message-ID: <AANLkTinkiwpmrTkh_bZshgCFYz2Ns4wB8dnjKMiyH7Q0@mail.gmail.com>
Subject: Re: [PATCH] Staging: comedi: Fixed long line lengths in drivers.c
From: Mark Rankilor <reodge@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@suse.de, Mithlesh Thukral <mithlesh@linsyssoft.com>,
       Bill Pemberton <wfp5p@virginia.edu>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 May 2010 20:05, Joe Perches <joe@perches.com> wrote:
> It's better to not just fix the checkpatch errors by simply
> wrapping the code, but rather to factor the code for clarity.
>
> Perhaps something like:

Joe, thanks for the help and code, it looks good so far to me, though
I haven't had time to look through thoroughly enough tonight.

I'll give it a longer look in my next hacking session :)

Cheers,
Mark
