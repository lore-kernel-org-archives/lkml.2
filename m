Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab1FMXc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 19:32:26 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49501 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab1FMXcY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 19:32:24 -0400
MIME-Version: 1.0
In-Reply-To: <d8b25dce-9086-45e3-8dc7-012947e47ed2@VA3EHSMHS018.ehs.local>
References: <20110613132935.16600.94753.stgit@ponder> <d8b25dce-9086-45e3-8dc7-012947e47ed2@VA3EHSMHS018.ehs.local>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 13 Jun 2011 17:32:04 -0600
X-Google-Sender-Auth: 23XAemMyEYu7juU4rWSPAx9ywkc
Message-ID: <BANLkTik-+6RSbE2ycm4zz+Cxm12UEnpC5g@mail.gmail.com>
Subject: Re: [RFC] (early draft) dt: Linux dt usage model documentation
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Cc: devicetree-discuss@lists.ozlabs.org, Randy Dunlap <rdunlap@xenotime.net>,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 5:29 PM, Stephen Neuendorffer
<stephen.neuendorffer@xilinx.com> wrote:
>
>> +Some time later, FDT infrastructure was generalized to be usable by
>> +all architectures.  At the time of this writing, 5 mainlined
>> +architectures (arm, mips, powerpc, sparc, and x86) and 1 out of
>
> microblaze too?

Oops, I knew I was missing something.  Thanks

g.

>
>> +mainline architecture (nios) have some level of DT support.
>> +
>
> Steve
>
> This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.
>
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
