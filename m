Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab2G0CmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 22:42:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61894 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab2G0CmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 22:42:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120726192803.0afb7eb2@debxo>
References: <1343346559-8416-1-git-send-email-yamanetoshi@gmail.com>
	<20120726192803.0afb7eb2@debxo>
Date: Fri, 27 Jul 2012 11:42:22 +0900
Message-ID: <CAOTypNQb-Qem0q_h4UGVmtKq6TWzkfX55KBaxGjyMSo3PXAfAw@mail.gmail.com>
Subject: Re: [PATCH] staging/olpc_dcon: fix checkpatch warnings
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 11:28 AM, Andres Salomon <dilinger@queued.net> wrote:
> On Fri, 27 Jul 2012 08:49:19 +0900
> Toshiaki Yamane <yamanetoshi@gmail.com> wrote:
>
>> Now checkpatch clean.
>>
>> $ find drivers/staging/olpc_dcon/ -name
>> "*.[ch]"|xargs ./scripts/checkpatch.pl \ -f --terse --nosummary|cut
>> -f3- -d":"|sort |uniq -c|sort -n 2  WARNING: msleep < 20ms can sleep
>> for up to 20ms; see Documentation/timers/timers-howto.txt 3  WARNING:
>
> NACK - please don't modify the msleep timings right now.  The pr_*
> changes are welcome, however.
>

I agree.
