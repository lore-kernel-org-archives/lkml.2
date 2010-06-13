Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0FMUdM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 16:33:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61938 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab0FMUdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 16:33:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oPcetnluXOyfAb0N+PKYJA6dARgqF6OTaxlXdYghamYSybN8rSX7BuIicGKPAsS8gV
         ZbrKI1i0i4jGBdjO2yxUObQvS1r+m0d2g7npo1F9X59xul2s9A3LgNXEEAkx1xL0vjkU
         nGMh6xyfrFgaMnRDuHCfmEcVfJPXqvbaoxGkI=
Subject: Re: BUG: using smp_processor_id() in preemptible code: s2disk
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Jiri Slaby <jslaby@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100613203352.GA3577@swordfish>
References: <20100613203352.GA3577@swordfish>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Jun 2010 23:33:03 +0300
Message-ID: <1276461183.2659.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-13 at 23:33 +0300, Sergey Senozhatsky wrote: 
> Hello,
> 
> .35-rc3, x86
> 
> Hit the following error today:

I confirm the same issue. Sorry for not reporting it earlier.


Best regards,
Maxim Levitsky

