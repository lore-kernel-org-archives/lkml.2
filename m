Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab1I2MNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 08:13:16 -0400
Received: from mga12.intel.com ([143.182.124.36]:35745 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751464Ab1I2MNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 08:13:14 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1109291042290.21622@tundra.namei.org>
References: <cover.1315921427.git.dmitry.kasatkin@intel.com>
	<1316525069.3189.4.camel@localhost.localdomain>
	<CALLzPKbPM-7Z4UphWvZUFxT9vF8XJSWyeUGTkLaM7--2A6y7eA@mail.gmail.com>
	<alpine.LRH.2.00.1109270914480.4126@tundra.namei.org>
	<CALLzPKa=DuhmTZ7enLH6LNKA1mimC9OJZoaCJrprrHJwg=mRdQ@mail.gmail.com>
	<20110929001424.GA17356@gondor.apana.org.au>
	<alpine.LRH.2.00.1109291042290.21622@tundra.namei.org>
Date: Thu, 29 Sep 2011 15:13:11 +0300
Message-ID: <CALLzPKa=hvRxwtaupOKO=UqdVZhLvsmzUSe3mzL93WuJxuT8xA@mail.gmail.com>
Subject: Re: [RFC v2.1 0/6] evm: digital signature verification extension
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: James Morris <jmorris@namei.org>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, Greg KH <greg@kroah.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 3:42 AM, James Morris <jmorris@namei.org> wrote:
> On Thu, 29 Sep 2011, Herbert Xu wrote:
>
>> Well if James is OK with adding the user for this then I'm fine
>> with adding the necessary infrastructure.
>
> Are you happy with the API?
>
>
> --
> James Morris
> <jmorris@namei.org>
>

Hello,

One comment earlier (some years ago) was to put MPI lib to the /lib folder.
Indeed it is a math "library"...
ksign.c can be also there..

Does /lib sounds better?
It does not break anything. It is just enabling technology for IMA/EVM.
And of course it will evolve further...

- Dmitry
