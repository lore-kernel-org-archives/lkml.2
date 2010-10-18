Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab0JRK2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 06:28:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33647 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab0JRK2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 06:28:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=n4+l1WYL3gkvWJ4msVbAkVpbV/Tfs1YfRg2Of4M0EkAil7AAg7lvZxeDYCVm3k2Bjp
         aU2kJVqRNqjlZPBAb4+2cF97BQ0QQ02pye+XG0+QS7UOie/Z6DWEEFLRe+MxI6+ln0Si
         JciFl4TxztT9Uci7zXuxSM4tqItDoBDUmZTd4=
Message-ID: <4CBC2171.4060204@gmail.com>
Date: Mon, 18 Oct 2010 03:29:05 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Finn Thain <fthain@telegraphics.com.au>, linux-kernel@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Matt Turner <mattst88@gmail.com>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [RFC 1/2 v7]Update broken web addresses in the kernel.
References: <1287250583-6856-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1010171941370.5468@nippy.intranet> <alpine.LNX.2.00.1010181103370.6879@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1010181103370.6879@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2010 02:03 AM, Jiri Kosina wrote:
> On Sun, 17 Oct 2010, Finn Thain wrote:
>
>>
>> Jiri, if you wish to merge these two patches, please go ahead and add
>> this tag:
>> Reviewed-by: Finn Thain<fthain@telegraphics.com.au>
>
> Both patches now applied. Thanks,
>

alright... special thanks to finn for all hard work/revs on this...

cheers...

Justin P. Mattock
