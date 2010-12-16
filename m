Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab0LPLAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 06:00:25 -0500
Received: from oversea.ee-post.com ([205.209.161.131]:56298 "ehlo
	oversea.ee-post.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab0LPLAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 06:00:23 -0500
X-Penetrate-Bounce: Yes
X-Lasthop: 116.246.17.251
Message-ID: <BECB6E558F0C4305830CC2A5CF2EB439@baoyb>
From: "baoyb" <baoyb@avit.org.cn>
To: "Greg KH" <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <alan@linux.intel.com>
References: <EF6DDE218DB34702B1FA84D6CD7EA771@baoyb> <20101208150738.GB5669@suse.de>
In-Reply-To: <20101208150738.GB5669@suse.de>
Subject: Re: Kernel Oops at tty_buffer_request_room when using pppd program (2.6.37-rc4)
Date: Thu, 16 Dec 2010 19:00:16 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All:
I have tested 2.6.37-rc5 and the bug still exist.
I also tested 2.6.32.24, the oops frequency is much lower than 2.6.37. (Only 
happened 2 times in one week).

Regards,
Baoyb

--------------------------------------------------
From: "Greg KH" <gregkh@suse.de>
Sent: Wednesday, December 08, 2010 11:07 PM
To: "baoyb" <baoyb@avit.org.cn>
Cc: <linux-kernel@vger.kernel.org>; <alan@linux.intel.com>
Subject: Re: Kernel Oops at tty_buffer_request_room when using pppd program 
(2.6.37-rc4)

> On Wed, Dec 08, 2010 at 09:55:09PM +0800, baoyb wrote:
>> Hi All:
>>
>> We are using a USB 3G card(HUAWEI e180) and wvdial+pppd(version
>> 2.4.5) program. Sometimes kernel will crash when pppd disconnect the
>> link. Our cpu platform is AMCC ppc405EX and kernel version is
>> 2.6.37-rc4.
>
> Can you try 2.6.37-rc5 and see if that fixed the issue?  A number of tty
> fixes went in between those two versions that should have resolved this.
>
> thanks,
>
> greg k-h
>
> __________ Information from ESET NOD32 Antivirus, version of virus 
> signature database 5682 (20101207) __________
>
> The message was checked by ESET NOD32 Antivirus.
>
> http://www.eset.com
>
>
> 
