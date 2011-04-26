Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab1DZUM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:12:28 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53328 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab1DZUM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:12:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hhqPLhYOiUUAxvdrtT9x33P2AfEJFIow8yc1/MpnAaTb+lMiAiDoep8UPyj068ndm0
         5Ta25d4yqPAePEiz18iXVmWVwRIwsMu33TgbV0EdbVdoIwwzbjgIVfSJ45/8ygTepj4Q
         CKCVqUAwuOHKa3qmO8b65RKr+qVQ3OcMmHavQ=
Message-ID: <4DB72726.6050506@lwfinger.net>
Date: Tue, 26 Apr 2011 15:12:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, wlanfae@realtek.com
Subject: Re: r8712u cannot set essid
References: <BANLkTi=fFg6+3DcBNwEOex0jASf1WiBRDQ@mail.gmail.com>	<4DB4E94C.2060505@lwfinger.net>	<BANLkTinA6GTTjP=MsVcCqmCA1Tgh-6bHjA@mail.gmail.com>	<4DB5C8FA.2030700@lwfinger.net>	<BANLkTi=syavY0Tw-Ny9-QhU=_Ryrbmkhfw@mail.gmail.com>	<4DB61645.8010001@lwfinger.net>	<BANLkTikWHxEnzZ+H1OgFv7AdmpmmcwVuzA@mail.gmail.com>	<4DB6E584.9040504@lwfinger.net>	<BANLkTin7F21PVKqtbohE6EucdinZ60x5=A@mail.gmail.com> <BANLkTi=MO6u_DOaL8DMvuB5uJybQO_hqWA@mail.gmail.com>
In-Reply-To: <BANLkTi=MO6u_DOaL8DMvuB5uJybQO_hqWA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2011 02:30 PM, Jeff Chua wrote:
> On Wed, Apr 27, 2011 at 12:24 AM, Jeff Chua<jeff.chua.linux@gmail.com>  wrote:
>> I hacked it a bit more, and now, it's all working. I'll send you the
>> patch shortly. Adhoc mode works now, and I've confirmed that my iPhone
>> can connect to it, get an IP and surf the net! The device is so tiny
>> and was contemplating on trying another brand.
>
> Larry,
>
> Here's the patch for adhoc mode. This should work. Just remember to
> set wpa_supplicant's ap_scan to either 1 or 2 (faster association). 0
> does not seem to work.

Thanks. Is this in addition to my previous patch, or is this one enough by itself?

Larry
