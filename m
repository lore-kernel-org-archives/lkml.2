Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab0LIHeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 02:34:23 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:39649 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab0LIHeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 02:34:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=DOy3UU7gEsX8PPY/TvqLuQdtSE7MV/l6D4XgA79X1lzW2tTFAkX8ssnLo3pzpiWT9O
         Z+ep6BIt2Y0JHvhyWhkAHghGiR0zeejuIfGdOXaKWRmQyYugwsusUEyOGICMSSgDT9WH
         y1Q+q7RCTbA35wjA70gft5C9laN7nNgEK6tyo=
MIME-Version: 1.0
In-Reply-To: <20101209073126.GA2212@debian.Jeff>
References: <20101209073126.GA2212@debian.Jeff>
Date: Thu, 9 Dec 2010 09:34:20 +0200
X-Google-Sender-Auth: Y6Nh7ZijAmUezKSgrjHEdlZ3tDk
Message-ID: <AANLkTiniTACjBkqpbc=Opd6v1UMe8j8YWkC0szTFrPrA@mail.gmail.com>
Subject: Re: format and standards issues fixes
From: Pekka Enberg <penberg@kernel.org>
To: Jeffrin Jose <ahiliation@yahoo.co.in>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 9:31 AM, Jeffrin Jose <ahiliation@yahoo.co.in> wrote:
> hello.
>
> I have fixed several issues with checkpatch.pl
> fixes include standards and format issues.
>
> i have attached the patch along with this mail.

Please send the patch as inline text in the email as per
Documentation/SubmittingPatches. People are less likely to review your
patches if you send them as attachments.

                        Pekka
