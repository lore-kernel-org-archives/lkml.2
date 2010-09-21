Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab0IUQJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:09:15 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:34598 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab0IUQJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:09:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=stWgH9IftgFdcbol//ExBfeajNEbAyhBwL93vDa1o+n4H075NhYJm3HfuOkgToiyM8
         tCS3Otu77W559CU+kAQ/g9TX9ve3G5Hm4uf+6u3VkOkOEnj72nJDB9P+Do1FRfQP0BsG
         Qc9NUaDymXnBlqbtmovzgOVUKG5WC3nUDejrE=
Message-ID: <4C98D8AA.80606@gmail.com>
Date: Tue, 21 Sep 2010 09:09:14 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Finn Thain <fthain@telegraphics.com.au>
CC: Matt Turner <mattst88@gmail.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Ben Pfaff <blp@cs.stanford.edu>, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH]Update-broken-web-addresses-in-the-kernel
References: <1285042724-19135-1-git-send-email-justinmattock@gmail.com> <AANLkTinE73z9QV0zriVE3bRtzMifWSGvG36hfvnA9biD@mail.gmail.com> <4C983C7D.1050000@gmail.com> <AANLkTimYp6ua743x9ze4fcU09ZZ=oZZd_iKCmU0WQ2h7@mail.gmail.com> <alpine.LNX.2.00.1009211516180.9370@nippy.intranet>
In-Reply-To: <alpine.LNX.2.00.1009211516180.9370@nippy.intranet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2010 10:17 PM, Finn Thain wrote:
>
> I would say that if a URL is in the web archive, then no patch is needed.
>
> Finn
>

before I go and remove all of the archive.org stuff, can I get some 
feedback from other people as well on having this used? i.e. if keeping 
the old broken link in the kernel, how will people know to go to 
archive.org or any other archive site to read the old info?, as opposed 
to already having this in there so people can just click and go?..

The idea to use archive.org came from this thread:
http://amailbox.org/mailarchive/linux-kernel/2010/7/21/4596207/thread
where there are people still wanting to read the old info.

Justin P. Mattock

