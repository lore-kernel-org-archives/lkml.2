Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab1DMIPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:15:40 -0400
Received: from smtp-out.google.com ([74.125.121.67]:40531 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab1DMIPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:15:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NHxRYK88nkiPDbZyv1Xqz4oxmQdZwcxPBCwdRg+E0OCILj54adZTMrNKcAnGsJnMJH
         CnTnq3/Gs7uA5F35H8Jw==
MIME-Version: 1.0
In-Reply-To: <20110413070259.GE4070@infomag.iguana.be>
References: <1302641290-30212-1-git-send-email-natg@google.com>
	<1302641387-30264-1-git-send-email-natg@google.com>
	<20110413070259.GE4070@infomag.iguana.be>
Date: Wed, 13 Apr 2011 01:15:33 -0700
Message-ID: <BANLkTimE4sNw1it8-te9Hk+earOVd6NeUg@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] Use "request_muxed_region" in it87 watchdog drivers
From: Natarajan Gurumoorthy <natg@google.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Mike Waychison <mikew@google.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wim,
      Old habits die hard. I will get rid of it and ship out a new patch.

Regards
Nat


On Wed, Apr 13, 2011 at 12:03 AM, Wim Van Sebroeck <wim@iguana.be> wrote:
> Hi Nat,
>
>> +     (void) request_muxed_region(REG, 2, NAME);
>
> Why do we need to typecast this? Can't we just use
> +       request_muxed_region(REG, 2, NAME);
>
> Kind regards,
> Wim.
>
>
>



-- 
Regards
Nat Gurumoorthy AB6SJ
