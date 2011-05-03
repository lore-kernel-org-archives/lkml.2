Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab1ECUDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:03:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54947 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab1ECUDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:03:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AlaLjzKYXTZLi2zV2YGtVjCNsrhWA1OEIBVX8XyfkJer0tqJ4pqni7/8tsQ7y25p0n
         M2DhczyQgDtrkwBUxzQyV7ksi3AvIR+m9Uqv9tE0rY+usu0PEmpyLTWGOUeGjV0JoVIc
         Na72cHbIm3RKfUaP7swtei3akf8Ax3iNIB6/0=
Message-ID: <4DC05F9C.2070802@lwfinger.net>
Date: Tue, 03 May 2011 15:03:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: John W Linville <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, chaoming_li@realsil.com.cn,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 00/12] rtlwifi: rtl8192se: Merge new driver
References: <4dc01587.AfSJXmRO80K/pl3f%Larry.Finger@lwfinger.net> <20110503150105.GC18648@gere.osrc.amd.com>
In-Reply-To: <20110503150105.GC18648@gere.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2011 10:01 AM, Borislav Petkov wrote:
> I think I have such a device in my Thinkpad:
>
> 03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8191SEvB Wireless LAN Controller [10ec:8172] (rev 10)
>
> I could give them a run soon. Do you have them in a tree somewhere I
> could pull?

Your device is claimed by the new driver.

You can get the code from

git://git.kernel.org/pub/scm/linux/kernel/git/lwfinger/rtl8192se.git

This tree is based on Linville's wireless-testing tree with these 12 patches 
applied.

Larry
