Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab1FJV1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 17:27:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54647 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab1FJV1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 17:27:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VCXuby6XXDMND9qlvQP70AkCAb5hZthvEAr6hHdVT47ROJRc8KNecFkCFqh1GJ8xhu
         DWGZ5jtR2CAcLXY76dkJk3IFS4++fgwRJi2lXtwAuBCf4RPlHM/47GFiOxPXGhjjEnOU
         rGb7vQcwhLojMJM1Pxn2AlEOecWlqUaYDK9Ew=
Message-ID: <4DF28C7D.7070201@gmail.com>
Date: Fri, 10 Jun 2011 23:28:29 +0200
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        cocci@diku.dk
Subject: Re: [Cocci] Re: status of constification
References: <20101108223844.GS5876@outflux.net> <4CD9BF25.4090306@gmail.com> <20110528031348.GA19633@outflux.net> <Pine.LNX.4.64.1105280838150.30088@ask.diku.dk> <4DEBF96D.3030209@gmail.com> <Pine.LNX.4.64.1106060948050.17498@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1106060948050.17498@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This problem seem to be solved.  At least, I don't see the problem for the
> following semantic patch:
>
> @@
> identifier i,x;
> type T;
> @@
>
> struct i {
>    ...
> - T x;
> + const T x;
>    ...
> };
>
> on the following code:
>
> struct i {
>    int a;
>    int b;
>    /* a comment */
>    int c;
>    int d;
> };
>
> The comment is preserved as well.

Hi,

I've just noticed there is a new version out (1.0.0-rc3), I will give it a try and let you know
the results.

--
Emese

