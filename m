Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689Ab1IZHdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 03:33:53 -0400
Received: from mga12.intel.com ([143.182.124.36]:21997 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750808Ab1IZHdw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 03:33:52 -0400
MIME-Version: 1.0
In-Reply-To: <1316525069.3189.4.camel@localhost.localdomain>
References: <cover.1315921427.git.dmitry.kasatkin@intel.com>
	<1316525069.3189.4.camel@localhost.localdomain>
Date: Mon, 26 Sep 2011 10:33:48 +0300
Message-ID: <CALLzPKbPM-7Z4UphWvZUFxT9vF8XJSWyeUGTkLaM7--2A6y7eA@mail.gmail.com>
Subject: Re: [RFC v2.1 0/6] evm: digital signature verification extension
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: herbert@gondor.hengli.com.au, linux-crypto <linux-crypto@vger.kernel.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, Greg KH <greg@kroah.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 4:24 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Tue, 2011-09-13 at 17:20 +0300, Dmitry Kasatkin wrote:
>> Hello,
>>
>> Changes to version 2.0:
>> - MPI patch has been split to smaller in order to go to mailing lists.
>>   First 2 patches include only source and header files which are needed
>>   to build ksign verification. Headers and sources are split just to
>>   meet 100k kernel.org limit.
>>   Last patch adds all rest soures from original ported MPI library.
>>
>> Changes to version 1.1:
>> - GnuPG MPI library has been refactored with lindent and checkpatch errors
>>   and warnings has been fixed.
>> - creation of evm keyring has been remove. It is done now in user space.
>> - related ksign and evm patches has been squashed.
>> - patch descriptions has been updated.
>>
>> As EVM patches were recently merged to security-testing-2.6#next,
>> it is a good time to resend evm signature verification patches for active
>> discussion. Last time I forgot --cc linux-crypto. Here it is.
>>
>> This patchset introduces digital signature extensions for the IMA/EVM kernel
>> integrity subsystem and is applied on the top of the EVM patches posted to
>> LSM mailing list earlier.
>
> Hi Herbert
>
> Back in March 2011, in preparation for EVM, Dmitry posted the GnuPG MPI
> library patch here on linux-crypto. The reason given for not upstreaming
> the MPI library, at the time, was for lack of an in kernel user
> (http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg05613.html).
> With the recent merging of the EVM patches in linux-next, via
> security-testing-2.6/#next, that is changing.  Any chance of re-opening
> the discussion?
>
> thanks,
>
> Mimi
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hi,

It seems nobody wants to share their thoughts about it?
Does this silence mean acceptance?
Should I prepare final patches for merge?

BR,
Dmitry
