Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab1EKP5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:57:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36367 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab1EKP5d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:57:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jm2q65llkPH9W3XLpqbH8wzQ54tJYvVkQwBM/vETucZ4rV8B4JjXhyEiLgiYmAISV+
         3yZdDtYwCB0nvzjG4JCmVgZ3/J+kfs7aJbncFPtHS6AgaSZY0Ih6orpaus2KQbzvznHJ
         RTBdKEj7rdF1/eGJnTqVl7prdYY+LtNMPxR1I=
MIME-Version: 1.0
In-Reply-To: <20110510161137.GA14522@kroah.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C16FB4712@USINDEVS01.corp.hds.com>
	<20110510161137.GA14522@kroah.com>
Date: Wed, 11 May 2011 21:09:26 +0800
Message-ID: <BANLkTimV8=o1zOeVJs9EA64kc+1=RZCJeA@mail.gmail.com>
Subject: Re: [RFC][PATCH] pstore: EFI Support
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "mikew@google.com" <mikew@google.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 12:11 AM, Greg KH <greg@kroah.com> wrote:
> On Tue, May 10, 2011 at 11:00:44AM -0400, Seiji Aguchi wrote:
>> Description of boot paremeters is following.
>>
>>  - efi_pstore_enable
>>    enable EFI support of pstore.
>>
>>  - efi_pstore_len
>>    Sets the buffer size of EFI variable space used by pstore.
>
> Please don't add new boot parameters if at all possible.  Distros will
> not know to enable them, and users don't know how to either.
>
> Use sane defaults, and provide ways to override them if needed, but
> don't rely on them for new functionality if at all possible.

I agree. It seems that we should enable this by default when APEI and
EFI are both enabled, this could be done by Kconfig.

Thanks.
