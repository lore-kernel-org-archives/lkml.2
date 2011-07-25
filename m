Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab1GYRP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 13:15:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:41581 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab1GYRPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 13:15:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=kBBwih5HnsxxhioSO6D7Yhz2B4e1qJds6FQvDhGtYvRBD08narh4u+H/SjgpFXfdT
	kk+ubPoKWyk7ZcmsvnHKA==
MIME-Version: 1.0
In-Reply-To: <CAC-0EqgJtddENZO_=kmjSy8-bocLf+ansDbpGwbkb+a3YLakLQ@mail.gmail.com>
References: <CAC-0EqgJtddENZO_=kmjSy8-bocLf+ansDbpGwbkb+a3YLakLQ@mail.gmail.com>
From: Mike Waychison <mikew@google.com>
Date: Mon, 25 Jul 2011 10:15:03 -0700
Message-ID: <CAGTjWtBw7JJHQFnxjDJEs58LyO2wX98aNWKtCmrQ3fYzebX2Xw@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] firmware: Add DMI entry types to the headers
To: David Hubbard <david.c.hubbard@gmail.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 4:22 PM, David Hubbard
<david.c.hubbard@gmail.com> wrote:
> Hi Mike,
>
>> In preparation for the upcoming commits, introduce the DMI entry types to
>> the headers.  These type names are based on those specified in the DMTF
>> SMBIOS specification version 2.7.1.
>>
>> Signed-off-by: Mike Waychison <mikew@google.com>
>> ---
>>  include/linux/dmi.h |   47 +++++++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 47 insertions(+), 0 deletions(-)
>
> I noticed a missing entry w.r.t. dmi_smbios_structure_type() in dmidecode.c:
>
> --- include/linux/dmi.h 2011-07-24 17:14:34.000000000 -0600
> +++ include/linux/dmi.h 2011-07-24 17:14:49.000000000 -0600
> @@ -57,6 +57,7 @@
>        DMI_ENTRY_OOB_REMOTE_ACCESS,
>        DMI_ENTRY_BIS_ENTRY,
>        DMI_ENTRY_SYSTEM_BOOT,
> +       DMI_ENTRY_64_MEM_ERROR,
>        DMI_ENTRY_MGMT_DEV,
>        DMI_ENTRY_MGMT_DEV_COMPONENT,
>        DMI_ENTRY_MGMT_DEV_THRES,

Good catch.  Looks like I screwed this up when transcribing the types
from the docs.   Good thing nobody depends on these later enums yet ;)

Can you post a patch in the canonical format specified in
Documentation/SubmittingPatches ?
