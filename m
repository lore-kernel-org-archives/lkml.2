Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab2AaLRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 06:17:21 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50772 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab2AaLRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 06:17:20 -0500
Message-ID: <4F27CDBC.5020201@suse.cz>
Date: Tue, 31 Jan 2012 12:17:16 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120124 Thunderbird/10.0
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ML netdev <netdev@vger.kernel.org>
Subject: Re: network regression: cannot rename netdev twice
References: <4F27120A.4040106@suse.cz> <CAPXgP12Sr2KzGJ9RA13QBOCkctb-z3O4+1uHOjANgMDDv2pxaQ@mail.gmail.com> <4F27C54F.1010107@suse.cz> <CAPXgP11=U_Y3LvJB2LRnXQ53y1WQQTqc0j1c7iva6ZXvF97wEw@mail.gmail.com> <4F27C9D4.3040105@suse.cz> <CAPXgP12pj6esZVmN-PYTVgJ+_MaAfmpa9hKoKKQZ+Y=Y-Kb4eA@mail.gmail.com>
In-Reply-To: <CAPXgP12pj6esZVmN-PYTVgJ+_MaAfmpa9hKoKKQZ+Y=Y-Kb4eA@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2012 12:13 PM, Kay Sievers wrote:
>>> Does is work, if you rename the devices to something else than ethX?
>>
>> Negative:
>> # ip link set eth0 name krtek
>> # ip link set krtek name jezek
>> RTNETLINK answers: No such file or directory
> 
> This is a command sequence you type manually?

Yea, and it is working with 3.3.0-rc1-next-20120124_64+. Not with
3.3.0-rc1-next-20120131_64+.

> You are sure that userspace is not working in the background,
> triggered by uevents, and comes into your way here?

Note that krtek exists after the first command. But cannot be renamed
further.

thanks,
-- 
js
suse labs
