Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab1EZI73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 04:59:29 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3672 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab1EZI70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 04:59:26 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4DDE165F.90806@broadcom.com>
Date: Thu, 26 May 2011 10:59:11 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Randy Dunlap" <rdunlap@xenotime.net>
cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Dan Carpenter" <error27@gmail.com>
Subject: Re: [RFC V1] lib: cordic: add library module for cordic angle
 calculation
References: <1306352426-1899-1-git-send-email-arend@broadcom.com>
 <20110525130438.c05605c7.rdunlap@xenotime.net>
 <4DDE0AB4.5020102@broadcom.com>
In-Reply-To: <4DDE0AB4.5020102@broadcom.com>
X-WSS-ID: 61C0C8C84NS12169435-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2011 10:09 AM, Arend van Spriel wrote:
> On 05/25/2011 10:04 PM, Randy Dunlap wrote:
>> On Wed, 25 May 2011 21:40:26 +0200 Arend van Spriel wrote:
>>> +/**
>>> + * struct - i/q coordinate.
>>    * struct cordic_iq - i/q coordinate
> The kernel-doc processing is pretty smart here. In the current form I
> get the html as attached. From that perspective your proposed change is
> not needed, but if your point is that it would be more clear to the mere
> mortal reading through the source code I can change it.
>
> Gr. AvS

Attached html does not get through the mail server. So here is part of 
the html source:

<h2>struct cordic_iq - i/q coordinate.</h2>
<b>struct cordic_iq</b> {<br>
&nbsp; &nbsp; <i>s32</i> <b>i</b>;<br>
&nbsp; &nbsp; <i>s32</i> <b>q</b>;<br>
};<br>
<h3>Members</h3>
<dl>
<dt><b>i</b>
<dd>real part of coordinate (in phase).
<dt><b>q</b>
<dd>imaginary part of coordinate (quadrature).
</dl>

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


