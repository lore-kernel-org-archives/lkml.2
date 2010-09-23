Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab0IWPgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 11:36:12 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55930 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab0IWPgL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 11:36:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VdJZFEWlsKRzd0vb67+/376FNLKiKk5V/Rr0X39RiUobKv3YXOkG9auXCNLm+sdYhX
         dCCNe50l1tnO4cDRaltn8ZShKIQblrxnA/AcwO5QOgSmoQEQRjQY2FnV8mnVfAcaIBdH
         LVPWSJb+eGjHaShhgUynGopS1uSPUVtYY0+Rg=
MIME-Version: 1.0
In-Reply-To: <1285255752.10687.20.camel@i7.infradead.org>
References: <1285255197-9262-1-git-send-email-dbaryshkov@gmail.com>
	<1285255197-9262-2-git-send-email-dbaryshkov@gmail.com>
	<1285255752.10687.20.camel@i7.infradead.org>
Date: Thu, 23 Sep 2010 19:36:09 +0400
Message-ID: <AANLkTi=eZEAt4EW6TjHE+YBYNtXcX3uPbUbdL2uNjS6=@mail.gmail.com>
Subject: Re: [PATCH 2/5] Add mkcis - a program that can create .cis from text description
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 7:29 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Thu, 2010-09-23 at 19:19 +0400, Dmitry Eremin-Solenikov wrote:
>> For CIS files (describing hardware on PCMCIA and some other busses)
>> binary file isn't the 'preferred for for modification' in most cases.
>> pcmcia-cs project have developed pack_cis program which can be used
>> (and was used most probably) to generate .cis files from simple text
>> descriptions. Import this code to the kernel under the name of mkcis.
>
> This is useful, thanks -- but NACK. The firmware/ directory of the
> kernel will hopefully die soon, and is no longer what's actually shipped
> by many distributions.
>
> We should be concentrating on the linux-firmware.git repository instead.

Should I redo this patch serie against linux-firmware.git (probably with
just putting .ct files near .cis)?

>
> --
> David Woodhouse                            Open Source Technology Centre
> David.Woodhouse@intel.com                              Intel Corporation
>
>



-- 
With best wishes
Dmitry
