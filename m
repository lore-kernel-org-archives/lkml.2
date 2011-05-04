Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab1EDTPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:15:07 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:41594 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1EDTPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:15:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OOJKw5EuTPcz9ihM9l9mnuyg8WxtAW8RBnRx9tds4ATu70lkopP6qFFA/0mrR/pSjL
         tmv5g6QyfZJmJ0m/6ZB1fg+TD0j56aL3WXAxHjKuyaYNe+Jo2mBdkmVMFQ0jNazBsFd3
         MHG28w+pHYKpOHmGJCN82nK1vuETiGht+ROYg=
Message-ID: <4DC1A5B5.4050605@lwfinger.net>
Date: Wed, 04 May 2011 14:15:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: John W Linville <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, chaoming_li@realsil.com.cn,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 00/12] rtlwifi: rtl8192se: Merge new driver
References: <4dc01587.AfSJXmRO80K/pl3f%Larry.Finger@lwfinger.net> <20110503150105.GC18648@gere.osrc.amd.com> <4DC05F9C.2070802@lwfinger.net> <20110504170131.GA12126@gere.osrc.amd.com> <4DC18AE5.4010708@lwfinger.net> <20110504180605.GB12126@gere.osrc.amd.com>
In-Reply-To: <20110504180605.GB12126@gere.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2011 01:06 PM, Borislav Petkov wrote:
> On Wed, May 04, 2011 at 12:20:37PM -0500, Larry Finger wrote:
>> You are very welcome. I'm glad to hear that it works for you. That
>> driver missed the 2.6.39 merge window due to an ASPM problem that
>> crashed my computer without any possibility of seeing what caused
>> the blowup. I was somewhat afraid that others would get similar
>> results even though Realsil did not see the problem.
>
> Right, so I saw the oops below while playing with the driver earlier
> but I attribute it to the fact that radio was switched off in the BIOS
> (rfkill show said "Hard blocked: yes" for the wireless device). After
> changing that I'm running smoothly so far. I'll keep you posted if I see
> anything while using it in the next weeks.
>
> Thanks.

Thanks for the dump. I don't think the oops was due to the wireless being 
switched off. It looks as if you do not have the CRDA package installed, thus 
the regulatory domain was not setup correctly. That is a condition I realize 
that I have not tested. As soon as I have a fix, I'll let you know. BTW, if my 
analysis is correct, this bug has been around since 2.6.37 when rtl8192ce was 
merged.

Larry
