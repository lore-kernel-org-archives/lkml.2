Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab0CaHS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 03:18:57 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43857 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab0CaHS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 03:18:56 -0400
Message-ID: <4BB2F75C.4060004@canonical.com>
Date: Wed, 31 Mar 2010 09:18:52 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, stable-commits@vger.kernel.org,
       gregkh@suse.de, davem@davemloft.net, stable@kernel.org
Subject: Re: [stable] patch sparc64-make-prom-entry-spinlock-nmi-safe.patch
 added to 2.6.32-stable tree
References: <12689584863184@kroah.org> <4BB1E98E.9050702@canonical.com> <20100330200522.GD1693@kroah.com>
In-Reply-To: <20100330200522.GD1693@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Mar 30, 2010 at 02:07:42PM +0200, Stefan Bader wrote:
>> This converted the raw_spinlock usage which is used in the upstream patch but
>> not available in 2.6.32 to normal spinlock usage. Should it get annotated to
>> document that?
> 
> why, you obviously figured that out :)
> 
> It's not the normal thing to do for backports otherwise we would be here
> all day long...

Sometimes its more or less to change. Well at least David saying "nah" and not
"hm argh" achieved half of what the intention of the suggested annotation was. :)

Thanks,
Stefan

> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

