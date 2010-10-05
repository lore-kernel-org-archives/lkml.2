Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0JETXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:23:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47010 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0JETXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:23:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bUYijAYvKqO2ygtAulDxAl0LdK++5MxiJt9w612zpNL1gOW0RnLHKtENedyY2WIrq5
         nXKFc5yz/cLk6UCetlYyrII3pj9Tt8SZqs+pHF05fmOIsLRCM0D3LKYneN+/kK+L9ez7
         O+A0lMHqf1waT2ZciuKtl41xaSMQ2DsoYR4fE=
MIME-Version: 1.0
In-Reply-To: <20101005190741.GC20825@kroah.com>
References: <1286208555-8829-1-git-send-email-felipe.contreras@gmail.com>
	<20101005190741.GC20825@kroah.com>
Date: Tue, 5 Oct 2010 22:23:52 +0300
Message-ID: <AANLkTikOBWxXh7uVrDxfW3OnwOM58JTXU76KUUoQWBWM@mail.gmail.com>
Subject: Re: [PATCH 0/2] omap: dsp: make the driver actually work
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Hiroshi Doyu <hiroshi.doyu@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 10:07 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, Oct 04, 2010 at 07:09:13PM +0300, Felipe Contreras wrote:
>> It seems the platform device was dropped from the migration of tidspbridge into
>> staging, plus the sdram meblock (previously bootmem) required for it work are
>> gone.
>>
>> Withouth these patches the driver loads, but doesn't do anything.
>>
>> A second issue with ioremap() still remains, but that can be solved by
>> reverting 309caa9.
>>
>> I think these might be worth to get into 2.6.36, if not, I have versions with
>> more changes; cleanups and so on.
>
> I've applied this to my staging-next tree, for .37, as it's not a big
> deal for .36.

Well, I thought it would be nice if the driver actually worked on .36,
but anyway, I'll rebase the rest of my cleanup patches and send them.
Hopefully I find a way to get rid of the ioremap() issue.

Cheers.

-- 
Felipe Contreras
