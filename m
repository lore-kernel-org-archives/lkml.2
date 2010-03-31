Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab0CaCkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:40:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47403 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab0CaCkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:40:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AG2SdqZUZEv8cjvm1G4jJAFe/OSC79tjHqe12r9dpEWLcjwpJ3rVyhohQiEiltgRB6
         o+rFahfg5hIrzyMgDheIDglqScEXMufzFRxSwTABq2M4pTtChPpaf0SJ02xwHlHAbYtt
         AC29QoUkZj85cV0rccJoDWu1U7yq5JS7OdxHk=
Message-ID: <4BB2B606.8040004@lwfinger.net>
Date: Tue, 30 Mar 2010 21:40:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.34-rc3
References: <4BB24E5F.3030703@lwfinger.net> <20100331021626.GB3520@pengutronix.de>
In-Reply-To: <20100331021626.GB3520@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2010 09:16 PM, Wolfram Sang wrote:
> 
>> Remember our old friend? See also
>> http://lkml.indiana.edu/hypermail/linux/kernel/1003.1/02769.html and a long
> 
> There is a patch available:
> 
> https://patchwork.kernel.org/patch/87436/
> (or https://bugzilla.kernel.org/show_bug.cgi?id=15548)
> 
> Seems it was jussed missed.
> 
>> related discussion at
>> http://lkml.indiana.edu/hypermail/linux/kernel/1003.1/02772.html.
> 
> The firmware bug should be gone, but there is also
> 
> https://patchwork.kernel.org/patch/87359/
> 
> pointing out a few more potential issues. I will resend it without the
> thermal_sys-part and hope I'll get some comments.

Glad to hear that these will soon be fixed.

Larry
