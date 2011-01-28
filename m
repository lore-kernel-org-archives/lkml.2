Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1A1WoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 17:44:20 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42588 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab1A1WoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 17:44:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=F6KGqoJHg3j7vWwbslZVa6H62h5UZ6AoK9GuJRI3Tu0pwO+XLZS6THw2QUqP7s1thp
         +8UzGyj/2IPe3HXvGB8ycmrylUuhgYH0dV8yOm89darcE634xlTzHsURpSOmATpVKHfI
         FRBtaIjS7ks8I6LVfH3o7iShyktdlEq6awMOE=
MIME-Version: 1.0
Date: Fri, 28 Jan 2011 22:44:18 +0000
Message-ID: <AANLkTimKhrCvyzmGsogxWUOsgiek1vnQ17Tjnhm0T=LM@mail.gmail.com>
Subject: Re: Bash not reacting to Ctrl-C
From: julie Sullivan <kernelmail.jms@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(apologies for not replying to original thread, I wasn't subscribed)

>Might be some Bash assumption or race that works under other OSs but somehow Linux
>does differently. IIRC Bash is being developed on MacOS-X.

Yep, and I can confirm that this behaviour is the same on MacOS-X too
(I tested Ingo's
bash scripts in my break on a machine at work today).
Ctrl-C is lost about once in every 10 times.

>See that '^C^C' line? That is where i had to do Ctrl-C twice.

I beat Ingo - I got three '^C's in a row on the Mac a couple of times :-)

Cheers
Julie
