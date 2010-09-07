Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab0IGJ5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 05:57:30 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51361 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab0IGJ5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 05:57:24 -0400
Message-ID: <4C860C21.40708@ru.mvista.com>
Date: Tue, 07 Sep 2010 13:55:45 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: "Gadiyar, Anand" <gadiyar@ti.com>, Maxim Osipov <maxim.osipov@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: Fix kernel oops with g_ether and Windows
References: <AANLkTinKBYzMwxEJarwN_HmKAORqJ7oiauj5JuXCo+rm@mail.gmail.com> <5A47E75E594F054BAF48C5E4FC4B92AB03291AE03E@dbde02.ent.ti.com> <20100906201852.GB5162@suse.de>
In-Reply-To: <20100906201852.GB5162@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07-09-2010 0:18, Greg KH wrote:

>>> Please find attached patch for
>>> https://bugzilla.kernel.org/show_bug.cgi?id=16023 problem.

>> Looks like this is already in greg's tree, but the patch has
>> checkpatch errors.

>> (Caught by an autobuild tool we're playing with).

    It was caught by me on the list too, right at the same day the patch was 
posted. The author remained silent though...

>> @Greg,
>> Would you like an updated patch fixing them?

> Please, that would be great.

    I think it's too late. You've sent it to Linus on 9/04 already.

> thanks,

> greg k-h

WBR, Sergei
