Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0EVIR0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:17:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40515 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab0EVIRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:17:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=FWMksuP0EeLB8sg6L5vfoe7boQsYKsLBCcZIJ3UNb0tmopF11PSQ1D/E03DaqzzhaG
         NTQRlhWrqEkzD4SS8cmRNW64JWwQfoRnOZrhEz3RMSgfnuit/ixUpHb8CSkQqxgjPcp6
         iMmdEYQ+cc24Sbf2NYNc58fttyQUdHbPmVdVk=
MIME-Version: 1.0
In-Reply-To: <20100521200139.30e60c62@virtuousgeek.org>
References: <20100521144859.0a5b18c9@virtuousgeek.org>
	 <alpine.LFD.2.00.1005211709330.3689@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1005211859030.3689@i5.linux-foundation.org>
	 <20100521200139.30e60c62@virtuousgeek.org>
Date: Sat, 22 May 2010 11:17:20 +0300
X-Google-Sender-Auth: 76PtiBeWcB-EIOxjEL3lQtMsAbk
Message-ID: <AANLkTimP_vAumk5qEawTjUU1nbqBzP0iq03Y-34xCpRa@mail.gmail.com>
Subject: Re: [git pull] PCI changes
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22, 2010 at 6:01 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Fri, 21 May 2010 18:59:58 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>>
>>
>> On Fri, 21 May 2010, Linus Torvalds wrote:
>> >
>> > I think the "not verified" is also because you actually didn't push it
>> > out..
>> >
>> > I'm getting "Already up-to-date".
>> >
>> > Or is it in some magic branch that you didn't actually mention at all?
>>
>> Ahh. It's in "linux-next". Not "for-linus" or "master".
>
> Yeah sorry, I had pushed but it hadn't mirrored yet...

You can use "git request-pull" against master.kernel.org to avoid the
mirroring problem.
