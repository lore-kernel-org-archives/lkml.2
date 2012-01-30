Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab2A3VKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:10:45 -0500
Received: from tuxonice.net ([96.126.116.212]:34233 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab2A3VKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:10:43 -0500
Message-ID: <4F27074D.2040006@tuxonice.net>
Date: Tue, 31 Jan 2012 08:10:37 +1100
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jan Kara <jack@suse.cz>, Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, Pavel Machek <pavel@ucw.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC][PATCH] PM / Sleep: Freeze filesystems during system suspend/hibernation
References: <201201281445.49377.rjw@sisk.pl> <20120130200040.GB7827@quack.suse.cz> <201201302205.34159.rjw@sisk.pl>
In-Reply-To: <201201302205.34159.rjw@sisk.pl>
X-TagToolbar-Keys: D20120131081037118
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 31/01/12 08:05, Rafael J. Wysocki wrote:
> On Monday, January 30, 2012, Jan Kara wrote:
>> On Sat 28-01-12 14:45:49, Rafael J. Wysocki wrote:
>>> +	/*
>>> +	 * Freeze in reverse order so filesystems depending on others are
>>> +	 * frozen in the right order (eg. loopback on ext3).
>>> +	 */
>>   Ho, hum, are you sure the order in super_blocks list is the one you need?
>> Maybe it is but I'm not sure you are guaranteed it is.
> 
> Well, is there any way I can get the right order?

Jan, what's the case where the reverse of mount order might be the wrong
order?

Regards,

Nigel
-- 
Evolution (n): A hypothetical process whereby improbable
events occur with alarming frequency, order arises from chaos, and
no one is given credit.
