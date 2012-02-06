Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab2BFQmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:42:03 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64717 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab2BFQmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:42:01 -0500
MIME-Version: 1.0
X-Originating-IP: [87.66.62.139]
In-Reply-To: <CAORVsuVCYp+Fmfaje-UDnv1=x0PqApML6Jb-Z6EG0425SuREMg@mail.gmail.com>
References: <1328227065-22045-1-git-send-email-venki@google.com>
	<CAN5iSWo-n7OER4i1tPoeGBhY_RY-nX=7n4B3mFv1f0JK074bhQ@mail.gmail.com>
	<20120205035057.GA4948@gs62>
	<201202051204.38717.rjw@sisk.pl>
	<CAORVsuVCYp+Fmfaje-UDnv1=x0PqApML6Jb-Z6EG0425SuREMg@mail.gmail.com>
Date: Mon, 6 Feb 2012 17:42:00 +0100
Message-ID: <CAORVsuW7mBCZdGqScX5jjaYDhijZH_H7vDKkJ4v6WWHn9rUsGw@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH] CPU C-state breakage with PM Qos change
From: Jean Pihet <jean.pihet@newoldbits.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: markgross@thegnar.org, Kevin Hilman <khilman@ti.com>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Pihet-XID, Jean" <j-pihet@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

On Mon, Feb 6, 2012 at 11:18 AM, Jean Pihet <jean.pihet@newoldbits.com> wrote:
> Hi Rafael, Mark,
>
> On Sun, Feb 5, 2012 at 12:04 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
...

>> In kernel/power/Makefile:
>>
>> obj-$(CONFIG_PM)                += main.o qos.o
>>
>> I guess that explains things. :-)
> Initially I thought we should have a way of disabling the feature on
> some (minimal) kernels and so thought CONFIG_PM was the option to use.
>
>> It's quite easy to make qos.o be independent of CONFIG_PM, in which case the
>> code added by Venki can be removed, so patches welcome (for 3.4, though).
> I am working on it, more to come soon.

I have a couple of patches ready, to be applied on 3.3-rc1 (so without
Venki's patch applied).
The first one is on PM QoS, the second one on per-device PM QoS. Is
the latter needed?

Please let me know and I will send them asap.

Regards,
Jean

>>
>> Thanks,
>> Rafael
