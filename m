Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0IUFLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 01:11:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61786 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab0IUFLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 01:11:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=q6dlxXycFN6IHaYfXK/DReVkHJi4NVlfJ8bGly/qQQisHLIGMAbwrvk8Ar7DuzwWkG
         VTxVZcGoRu9w4yBaIGh/3cQcNLUSHNg61zIjydRCT2pG4ligSoPOEMaCQBKImOB4aRAO
         Q4JvBvC6ak6oAGNyn52Wsw3Do8dnW3W6TNQw8=
MIME-Version: 1.0
In-Reply-To: <4C983C7D.1050000@gmail.com>
References: <1285042724-19135-1-git-send-email-justinmattock@gmail.com>
 <AANLkTinE73z9QV0zriVE3bRtzMifWSGvG36hfvnA9biD@mail.gmail.com> <4C983C7D.1050000@gmail.com>
From: Matt Turner <mattst88@gmail.com>
Date: Tue, 21 Sep 2010 01:11:20 -0400
Message-ID: <AANLkTimYp6ua743x9ze4fcU09ZZ=oZZd_iKCmU0WQ2h7@mail.gmail.com>
Subject: Re: [PATCH]Update-broken-web-addresses-in-the-kernel
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Ben Pfaff <blp@cs.stanford.edu>, Mike Frysinger <vapier.adi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 1:02 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> didnt even think about that.. I really appreciate you pointing this out..
>  I'll go through the whole thing and see if I can figure a good fix for the
> archive.org stuff

Just checked, and you can modify the links like so:

- http://web.archive.org/web/*/http://ftp.digital.com/pub/DEC/axppci/ref_interrupts.txt
+ http://web.archive.org/web/%2A/http://ftp.digital.com/pub/DEC/axppci/ref_interrupts.txt

So, change * to %2A (it's ASCII code in hex).

I guess that's the least clunky fix.

Matt
