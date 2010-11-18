Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252Ab0KRPyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:54:07 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43571 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758858Ab0KRPyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:54:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=A/BMmMUwDzI9Ak/WAOdjVIWzty42zE8Xuzh+dtIFUddFue29K4qEC0IiqV1zuuBx/5
         3z/kff7Decp9R1//t1UNH5xTvkiCED3sQvfS6xj2VgCj6cTCpC7DefWJgO6+MwtFscUp
         X0YsGWF+8iyyhbVbuvgSjqXNP+nQjlFTpSaR0=
MIME-Version: 1.0
In-Reply-To: <20101118153856.GA27671@ericsson.com>
References: <AANLkTi=n7f_40ZdLBd4rYC-PgVABHp_gEWKm264n=yjC@mail.gmail.com>
	<1289340866.22931.304.camel@groeck-laptop>
	<AANLkTinEzMPxEnrEY5K8u5qLkQutU0vdRh_vOGU=QOCF@mail.gmail.com>
	<20101116150305.GA4442@ericsson.com>
	<AANLkTikQ9X0ntcBfD391zsyAZ1BfCCD1-DcKBb-O8kJn@mail.gmail.com>
	<20101118153856.GA27671@ericsson.com>
Date: Thu, 18 Nov 2010 16:54:05 +0100
Message-ID: <AANLkTi=VPh-s3UAJLoN-CF7hyaP67E7dTrcpKAodAmdT@mail.gmail.com>
Subject: Re: [PATCH] hwmon: (lm95241) Rewritten without using macros
From: Davide Rizzo <elpa.rizzo@gmail.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: LM Sensors <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/18 Guenter Roeck <guenter.roeck@ericsson.com>:
> Hi Davide,
>

Hi Guenter,

> Looks like you still have trouble with line wraps. You might want to get this fixed;
> having to figure out why the patch does not apply is a bit annoying.
>

You said me that attaching the patch to the mail is not correct.
First times I copy/pasted from kate, that broke tabs.
The last time I copy/pasted from kwrite, that seemed me correct (but
you're saying me that it isn't).
I'm using gmail, please explain me how to attach a patch to the e-mail.

> Moving include statements around is just a whitespace change and should be avoided.
> Also, you added a blank line at the end of the file which causes a git whitespace error
> when applying the patch.
>
> No need to retransmit. I fixed both and applied the patch with a couple of additional
> formatting changes to make the file checkpatch clean.
>
> Thanks,
> Guenter
>

I thank you,
Davide.


-- 
All difficult problems have a simple solution. That is wrong. [A. Einstein]
