Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab1EOIyk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 04:54:40 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41194 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab1EOIyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 04:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dlT74pTaG5f6S43dmyFIkf8rZnQeoF+gA8hLgHwPsLlt/DWIxlIeRUAlf/Vxz+ZBSO
         eszeZdTtQAl9qW3uQuOnh9UWnHkW/JlCreAWzGD66NxzjPr0ZGN/kdoRUfQCuJKM6YwU
         lSxWithZKuCmWT0aPMaM/fISe9nWDyL+rPKgE=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1105141827270.3078@ionos>
References: <alpine.LFD.2.00.1105141749180.29326@localhost6.localdomain6>
	<alpine.LFD.2.02.1105141827270.3078@ionos>
Date: Sun, 15 May 2011 10:54:37 +0200
X-Google-Sender-Auth: O0WAvLdhUNolNHvzvESKTFwUf5A
Message-ID: <BANLkTim68rrUkRi0r-5xo4T10r5ALgcQhg@mail.gmail.com>
Subject: Re: merge of real-time 2.6.33.9-rt31 with stable 2.6.33.13
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <Carsten.Emde@osadl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 6:28 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sat, 14 May 2011, John Kacur wrote:
>> I did some light testing merging 2.6.33.13 into real-time 2.6.33.9-rt31.
>> In addition I cherry-picked 3c955b407a084810f57260d61548cc92c14bc627
>> in order to compile on newer distros.
>
> Thanks.
>
>> Here is the result of cyclic test on one machine
>> sudo ./cyclictest -t32 -p 80 -n -i 10000 -l 10000
>> policy: fifo: loadavg: 0.00 0.00 0.00 1/541 3759
>>
>> T: 0 ( 3728) P:80 I:10000 C:  10000 Min:      7 Act:  104 Avg:  114 Max:     470
>
> The numbers are weird. How does that compare to older kernels on that
> machine with the same test?

Note this was on a machine with a straight Fedora install, and no -rt
packages or tuning. That being the case, the numbers are no better or
worse than recent -rt kernels. I can get you numbers with the last
kernel if you wish, on Monday. Perhaps Carsten would be interested in
running his tests?

John
