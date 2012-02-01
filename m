Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab2BASsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 13:48:47 -0500
Received: from mga12.intel.com ([143.182.124.36]:25772 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753336Ab2BASsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 13:48:45 -0500
MIME-Version: 1.0
In-Reply-To: <20120201.125245.681472105466012081.davem@davemloft.net>
References: <alpine.LRH.2.00.1202020037340.20463@tundra.namei.org>
	<20120201.125245.681472105466012081.davem@davemloft.net>
Date: Wed, 1 Feb 2012 20:48:43 +0200
Message-ID: <CALLzPKZ6AzsAzd0mWBChf2XZ0gBEAUjzsAm6YfqMiZVOVzYiiw@mail.gmail.com>
Subject: Re: [GIT] Fixes for MPI library
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: David Miller <davem@davemloft.net>
Cc: jmorris@namei.org, torvalds@linux-foundation.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 7:52 PM, David Miller <davem@davemloft.net> wrote:
> From: James Morris <jmorris@namei.org>
> Date: Thu, 2 Feb 2012 00:39:46 +1100 (EST)
>
>> Hi Linus,
>>
>> Please pull these fixes for the MPI library.
>>
>> Thanks to Tetsuo Handa for reviewing and analyzing the code.
>>
>>
>> The following changes since commit 62aa2b537c6f5957afd98e29f96897419ed5ebab:
>>   Linus Torvalds (1):
>>         Linux 3.3-rc2
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus
>>
>> Dmitry Kasatkin (11):
>>       lib/mpi: added missing NULL check
>>       lib/mpi: replaced MPI_NULL with normal NULL
>>       lib/mpi: return error code on dividing by zero
>>       lib/mpi: checks for zero divisor length
>>       lib/mpi: removed unused functions
>>       lib/digsig: additional sanity checks against badly formated key payload
>>       lib/digsig: pkcs_1_v1_5_decode_emsa cleanup
>>       lib/mpi: check for possible zero length
>>       lib/mpi: added comment on divide by 0 case
>>       lib/mpi: added missing NULL check
>>       lib/digsig: checks for NULL return value
>
> What happened to the sparc 32-bit build fixes I posted to Dmitry the other
> week?

I notice you have not sent it to lsm.
James, can you take them or I/David need to resend them?

- Dmitry

> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
