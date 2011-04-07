Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab1DGL13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 07:27:29 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64694 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab1DGL12 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 07:27:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=gsl8TnpJ1ZIPxuYnHzM9hIaU0Dute6E1LbtpAPC+1SSMOpOcu2C6bVlFkPCVxatLHk
         ZqyZSAalr+FKKPUUx7EfQpR1eV8REUFM2kyFROfeA6jvHZz2YE8xxpCbnMGTKfDcDHHY
         m0dpw3zCdCk5TuMwMlpkVOwfxjY2ZtHPqqMzA=
MIME-Version: 1.0
In-Reply-To: <20110407075703.GD24879@elte.hu>
References: <cover.1302137785.git.luto@mit.edu> <e210b8eea527894eaf3aec8c30c8d2747e87a524.1302137785.git.luto@mit.edu>
 <20110407075703.GD24879@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 7 Apr 2011 07:27:07 -0400
X-Google-Sender-Auth: 67fMsHaH8lO_Wqv2tTIpOakSofI
Message-ID: <BANLkTikDDkq7P0MDwrScbrcvJEN9rmVAKQ@mail.gmail.com>
Subject: Re: [RFT/PATCH v2 4/6] x86-64: vclock_gettime(CLOCK_MONOTONIC) can't
 ever see nsec < 0
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 7, 2011 at 3:57 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andy Lutomirski <luto@MIT.EDU> wrote:
>
>> +
>> +     /* wall_time_nsec, vgetns(), and wall_to_monotonic.tv_nsec
>> +      * are all guaranteed to be nonnegative.
>> +      */
>
>> +     /* wall_time_nsec and wall_to_monotonic.tv_nsec are
>> +      * guaranteed to be between 0 and NSEC_PER_SEC.
>> +      */
>
> Nor have you addressed stylistic review feedback i gave before ...
>
> Really, we absolutely must insist on 110% attention to small details for
> patches that modify assembly code.

Crud, I fixed most of those.  I'll get these in v3.  (I assume you're
talking about comment style.)

--Andy

>
> Thanks,
>
>        Ingo
>
