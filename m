Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab0EGIPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:15:08 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:47830 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab0EGIPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:15:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        b=iNHuVMD45Fx8cuM3/ayYfMa/X1dx8Ol6o0JBEGwqpcDKcAO3PC8BVfBKQYzj7hL5B2
         OmkNA9OLrDRG7zLVgZq1E7VlSoRoeI4OPm9lvoCk/OQlZz7vBgMyylSZr+rUmls9BZBP
         811HHZbtpxrrMqT4jeNbPIpKHdamR1QcWIgnU=
MIME-Version: 1.0
In-Reply-To: <AANLkTingM7EsCtbElXTNzzjZt4kG5acQtbt5mJEIVbrW@mail.gmail.com>
References: <AANLkTingM7EsCtbElXTNzzjZt4kG5acQtbt5mJEIVbrW@mail.gmail.com>
Date: Fri, 7 May 2010 18:14:58 +1000
X-Google-Sender-Auth: UPIHjDEJoIME16Rz9x206I_Iwjg
Message-ID: <AANLkTiku49O-IKX0NwDtUoDEQyRT2VPcKiNVrSMbOR38@mail.gmail.com>
Subject: Re: Regression: monitor fails to sleep/suspend, forced to reboot to 
	correct. 2.6.34-rc6
From: Lex Hider <floss@lex.hider.name>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 May 2010 13:00, Justin P. Mattock <justinmattock@gmail.com> wrote:

    On 05/06/2010 07:30 PM, Lex Hider wrote:

        Hi,

        My current setup has worked on previous kernels, I think the problem
        has begun with 2.6.32.

        If the monitor goes to standby/suspend it shows:

        "Out of Range

        H.frequency 33 KHz
        V.frequency 31 Hz"

        I can test this with running: "xset dpms force standby" or "xset dpms
        force suspend".

        I can no longer switch to console with Ctrl+Alt+F2, etc, and must
        reboot to be able to use my system again.

        Please advise what additional information/testing I can provide to
        make sure this regression gets fixed for 2.6.34.

        This bug appears to affect all recent distros as they are 2.6.32 based
        (ubuntu lts, debian, rhel6).

        I have reported the following bugs with little response. I am unsure
        whether I have filed bugs in the correct place or against the correct
        component.

        http://bugs.freedesktop.org/show_bug.cgi?id=26423
        https://bugzilla.redhat.com/show_bug.cgi?id=581898

        Please CC me in on any replies.

        Thanks,

        Lex.
        --
        To unsubscribe from this list: send the line "unsubscribe
linux-kernel" in
        the body of a message to majordomo@vger.kernel.org
        More majordomo info at  http://vger.kernel.org/majordomo-info.html
        Please read the FAQ at  http://www.tux.org/lkml/


    Can you do a bisect?
    (2.6.32 - HEAD shouldn't
    take too long).

    Justin P. Mattock


I'm still a git newbie. What specific command should I run and what
output to post?
You want me to do it against HEAD vs "latest known working version"?

Thanks,

Lex.
