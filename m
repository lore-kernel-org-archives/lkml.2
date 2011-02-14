Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab1BNIoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 03:44:16 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57040 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1BNIoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 03:44:13 -0500
Message-ID: <1F33D30F9B2D47ECA80CEC807A6C0727@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Wolfgang Grandegger" <wg@grandegger.com>
Cc: "Kurt Van Dijck" <kurt.van.dijck@eia.be>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <m-watkins@ti.com>,
        <nsekhar@ti.com>, <sachi@mistralsolutions.com>,
        "open list:CAN NETWORK DRIVERS" <socketcan-core@lists.berlios.de>,
        "open list:CAN NETWORK DRIVERS" <netdev@vger.kernel.org>,
        "open list" <linux-kernel@vger.kernel.org>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <1297435892-28278-10-git-send-email-subhasish@mistralsolutions.com> <20110211150602.GB373@e-circ.dyndns.org> <C1C4300CE90A406FBDA2388D5491FAD5@subhasishg> <4D58D854.5090503@grandegger.com>
In-Reply-To: <4D58D854.5090503@grandegger.com>
Subject: Re: [PATCH v2 09/13] can: pruss CAN driver.
Date: Mon, 14 Feb 2011 14:15:06 +0530
Organization: Mistral Solutions
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

That is correct, we receive only pre-programmed CAN ids and "all" or "range" 
implementation is not there in the PRU firmware.
Will check the sysfs option and update.

--------------------------------------------------
From: "Wolfgang Grandegger" <wg@grandegger.com>
Sent: Monday, February 14, 2011 12:53 PM
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Cc: "Kurt Van Dijck" <kurt.van.dijck@eia.be>; 
<davinci-linux-open-source@linux.davincidsp.com>; 
<linux-arm-kernel@lists.infradead.org>; <m-watkins@ti.com>; 
<nsekhar@ti.com>; <sachi@mistralsolutions.com>; "open list:CAN NETWORK 
DRIVERS" <socketcan-core@lists.berlios.de>; "open list:CAN NETWORK DRIVERS" 
<netdev@vger.kernel.org>; "open list" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 09/13] can: pruss CAN driver.

> On 02/14/2011 05:54 AM, Subhasish Ghosh wrote:
>> Hello,
>>
>> I had a discussion regarding this with Wolfgang:
>>
>> http://www.mail-archive.com/socketcan-users@lists.berlios.de/msg00324.html
>>
>> The problem here is that we must configure the mailbox ID's and this
>> support is not available in the socketCan sub-system.
>
> To understand you correctly. A mailbox (or message object) can *only*
> receive messages with the pre-programmed CAN id? Isn't there a chance to
> receive all or a range of CAN ids? That's a very unusual piece of
> hardware. Anyway, using kernel configuration parameters to define the
> CAN id's would be the less flexible method. The user will not have a
> chance to change them at run-time. Using SysFS files would already be
> much better.
>
> Wolfgang. 

