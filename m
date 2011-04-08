Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab1DHPKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 11:10:43 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36769 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533Ab1DHPKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 11:10:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cdOSltA1C1jTO7FlNp/um0V23AWnoTzTCovoAqzU2Bcz7Pbr2KU1w/JhwCb/ZoSWx1
         hdzXdRVKzPfx/W0S5vzdigD9euPgY0BCPvZdDjzMbpzMhIctk3N8jtloguuvVv6XzNgU
         OUQfsNdTdibimLHFAiKMo0WMRSeuVYkJ36Z9U=
Message-ID: <4D9F2568.50204@gmail.com>
Date: Fri, 08 Apr 2011 08:10:32 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: Re: [RFC 3/5]arch:mips:pmc-sierra:msp71xx:Makefile Remove unused
 config in the Makefile.
References: <1302022702-24541-1-git-send-email-justinmattock@gmail.com> <1302022702-24541-3-git-send-email-justinmattock@gmail.com> <20110408130811.GA17431@linux-mips.org>
In-Reply-To: <20110408130811.GA17431@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2011 06:08 AM, Ralf Baechle wrote:
> On Tue, Apr 05, 2011 at 09:58:20AM -0700, Justin P. Mattock wrote:
>
>> The patch below removes an unused config variable found by using a kernel
>> cleanup script.
>> Note: I did try to cross compile these but hit erros while doing so..
>> (gcc is not setup to cross compile) and am unsure if anymore needs to be done.
>> Please have a look if/when anybody has free time.
>
> NACK.
>
> This need a rewrite, not just chainsawing.  Your code was only touching
> the makefile anyway, not the two referenced C files.
>
>   Ralf
>
>    Ralf
>

alright!!

Justin P. Mattock
