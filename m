Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987Ab0HEJ6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 05:58:48 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58560 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab0HEJ6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 05:58:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=weJhNqjU9K9V9DqJpxKAPYtpZgdOhSrUfJbyM5kWKgd3GA77e8S9tTk0aj2fy6YP2y
         W7qTp8gQfBdmXRDqpA5PhE4MjJD6DTaFk3iDlK0qsoryvTkuhGApb+mYbTTEsxXcLFeN
         pYy43F7CVxWIVPk5yra30SBvQmf2u20VRTegw=
MIME-Version: 1.0
In-Reply-To: <20100805062431.GA1546@ucw.cz>
References: <1280440089-3203-1-git-send-email-john.johansen@canonical.com>
	<alpine.LRH.2.00.1007300903440.7719@tundra.namei.org>
	<20100805062431.GA1546@ucw.cz>
Date: Thu, 5 Aug 2010 11:58:42 +0200
Message-ID: <AANLkTimku1sLsZyg3=2Oo9Xq=7U-hDKtc1Fy3ZytxZYS@mail.gmail.com>
Subject: Re: [AppArmor #7 0/13] AppArmor security module
From: Jan III Sobieski <jan3sobi3ski@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2010/8/5 Pavel Machek <pavel@ucw.cz>:
> On Fri 2010-07-30 09:05:23, James Morris wrote:
>> On Thu, 29 Jul 2010, John Johansen wrote:
>>
>> > This is the seveth general posting of the newest version of the
>> > AppArmor security module it has been rewritten to use the security_path
>> > hooks instead of the previous vfs approach.  The current implementation
>> > is aimed at being as semantically close to previous versions of AppArmor
>> > as possible while using the existing LSM infrastructure.
>>
>> Applied to
>> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
>>
>> Please carry out any further development against the above tree.
>>
>> Note that I added the patch below to update AA against the latest
>> version of path_truncate:
>
> Ok, so now we have two name-based "security" modules. Can we at least
> drop TOMOYO? That seems to have all apparmor disadvantages plus some
> more...

Great idea! I suggest also to throw away the unnecessary filesystems.
Ext3 is great - who needs Ext4 or XFS?

-- 
Jan III Sobieski
