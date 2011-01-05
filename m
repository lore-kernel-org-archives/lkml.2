Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482Ab1AEHAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 02:00:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40620 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab1AEHAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 02:00:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lCkvXW0G+cRQBTdEblaMcNEp0NzlhrysGr+UROfj7BgqEBziQf40hJz/cHxlRgxQAL
         UGxiCqriHW2TOqzzm1aXkyqqGVeOpCr17JihChl0a82PWDmREiMUgoZZcDVEKlpmDBfV
         TKuEK/l85nEEIMEO6UckwIsmKc3MPWkWOCa9M=
Date: Wed, 5 Jan 2011 08:00:39 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richard.cochran@omicron.at>
Subject: Re: [PATCH 2/3] ntp: add ADJ_SETOFFSET mode bit
Message-ID: <20110105070039.GA2817@riccoc20.at.omicron.at>
References: <1293493244-17583-1-git-send-email-john.stultz@linaro.org>
 <1293493244-17583-3-git-send-email-john.stultz@linaro.org>
 <AANLkTi=LqkC-tKzbb6y=iL0UvFYcfcHSuX=jVVFCk1uR@mail.gmail.com>
 <1294087466.2571.89.camel@work-vm>
 <20110104083733.GA4563@riccoc20.at.omicron.at>
 <1294168111.2694.3.camel@work-vm>
 <12d52d09b05.7801197194177918524.-8125715123212004756@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12d52d09b05.7801197194177918524.-8125715123212004756@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 08:52:58PM +0000, Kuwahara,T. wrote:
> You can obtain a more recent version of the timex.h and its related documentations from:
> http://www.eecis.udel.edu/~mills/ntp/html/kern.html
> 
> Download "nanokernel.tar.gz" and extract it.

Following the link, I get:

> wget ftp://ftp.udel.edu/pub/ntp/software/nanokernel.tar.gz
--2011-01-05 07:58:39--  ftp://ftp.udel.edu/pub/ntp/software/nanokernel.tar.gz
           => `nanokernel.tar.gz'
Resolving ftp.udel.edu... 128.4.40.10
Connecting to ftp.udel.edu|128.4.40.10|:21... failed: Connection refused.


