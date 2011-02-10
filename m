Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab1BJVHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:07:35 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44443 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750Ab1BJVHd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:07:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OHtHX1REwW6wLG2H1wATVhs1tG6Jk8xS+LBZHcq1uPJs3l1xHqHw0m38MdIBrNJJb4
         +NZZZ15SoqNrN50yBkiCUduBhZ6x/YkrJRLylEC4RxseVA6mU7UH1XDvgFwVeHQoKVyE
         lYLCmtHlmZ41+cE0cvubXFkF7St1vfWLWI9tU=
MIME-Version: 1.0
In-Reply-To: <20110128163315.1e4e8346.akpm@linux-foundation.org>
References: <AANLkTikrKEY7Zt5HvxQcJLk9eGne0BGD82NFEiWO4smt@mail.gmail.com>
	<20110128163315.1e4e8346.akpm@linux-foundation.org>
Date: Thu, 10 Feb 2011 19:07:31 -0200
Message-ID: <AANLkTikV9Ncy3Jki1G20SrzA_HMiAk_hF3qY8U+vpZ1D@mail.gmail.com>
Subject: Re: jme driver loses connection after resuming from suspend
From: "Leonardo  L. P. da Mata" <barroca@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Guo-Fu Tseng <cooldavid@cooldavid.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated information on the bug, Guo-Fu Tseng says that might not be a
bug on the driver, but i've tested other network cards and they don't
share the same issue.

Also, on interesting update that people may consider is that after
running tcpdump on the device, the network starts working again.
Information are updated in the bug.

On Fri, Jan 28, 2011 at 10:33 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> (cc's added)
>
> On Fri, 28 Jan 2011 16:03:11 -0200
> "Leonardo  L. P. da Mata" <barroca@gmail.com> wrote:
>
>> Hello, i'm testing the kernel 2.6.37 on my hardware, Once connect on
>> wired network, i call the suspend with:
>> echo "mem" >/sys/power/state
>>
>> The system goes on suspend. After resuming from suspend, the network card
>> cannot be used anymore.
>>
>>
>> The bug is reported here:
>>  https://bugzilla.kernel.org/show_bug.cgi?id=27692
>>
>> Can you please point me to similar problems on other network cards so
>> i can get possible solutions on this.
>
>



-- 
Leonardo Luiz Padovani da Mata
barroca@gmail.com

"May the force be with you, always"
"Nerd Pride... eu tenho. Voce tem?"
