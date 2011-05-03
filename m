Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab1ECQph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:45:37 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53236 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab1ECQpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:45:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Jy4tmUywqhDd8w20VrC497HUwG5VvTan1DFvpy6h152pqr3zzP+LGvhnCK/VXTeBCf
         OM0eiFy4t1MkCSK1Gw9BROQwaSt3cq261DdNxrW0P54rOab9QwuBKD0gfHK+RMC19yBw
         vVp5i+92wu44XukyPtmtlx6QhQV/L0Y7nuZLs=
Message-ID: <4DC0312A.4040303@lwfinger.net>
Date: Tue, 03 May 2011 11:45:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Walter Goldens <goldenstranger@yahoo.com>
CC: John W Linville <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, chaoming_li@realsil.com.cn
Subject: Re: [PATCH 00/12] rtlwifi: rtl8192se: Merge new driver
References: <776913.88107.qm@web161609.mail.bf1.yahoo.com>
In-Reply-To: <776913.88107.qm@web161609.mail.bf1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2011 10:59 AM, Walter Goldens wrote:
>
>> This set of patches introduces a driver for the RTL8192SE PCI devices.
>
> Any estimates on the *SU driver? :)

Now that rtl8192se is submitted, I will start work on the driver for the 
RTL8192DE devices. After that will be the RTL8191SU. It has lower priority 
because r8712u from staging handles those devices. It is not based on mac80211, 
but it works.

Larry
