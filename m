Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab1INTyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 15:54:24 -0400
Received: from claw.goop.org ([74.207.240.146]:37746 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932905Ab1INTyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 15:54:23 -0400
Message-ID: <4E710660.1060101@goop.org>
Date: Wed, 14 Sep 2011 12:54:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: Philip Rakity <prakity@marvell.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Manoj Iyer <manoj.iyer@canonical.com>
Subject: Re: SDHCI regression since 2.6.39
References: <4E6EA3E4.5080401@goop.org> <m2bouo37by.fsf@bob.laptop.org> <4E6F8C24.3090207@goop.org> <m2wrdc1i5b.fsf@bob.laptop.org> <4E6FA44F.1050705@goop.org> <m2aaa89t1m.fsf@bob.laptop.org> <alpine.DEB.2.02.1109131419430.3556@lazy> <4E6FBCA1.6040307@goop.org> <D45CBF70-F0B1-453A-9E31-A621F52C21B9@marvell.com> <4E6FC422.9080306@goop.org> <7C3ED924-555D-4C50-9000-36077650328C@marvell.com> <4E6FCE28.5040403@goop.org> <F54ECF19-5E4C-40A6-8E26-99BF223F9FE2@marvell.com> <4E6FDA0B.9060007@goop.org> <4E6FDC3E.8030702@goop.org> <003A4041-99F9-4598-AB9A-D08C76CDAECB@marvell.com> <4E6FFADE.5090004@goop.org> <m2k49b9qvu.fsf@bob.laptop.org> <4E70D62B.2030007@goop.org> <m2boun9dg1.fsf@bob.laptop.org>
In-Reply-To: <m2boun9dg1.fsf@bob.laptop.org>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2011 11:38 AM, Chris Ball wrote:
> Hi,
>
> On Wed, Sep 14 2011, Jeremy Fitzhardinge wrote:
>> I powered it off with battery unplugged for about an hour, and rebooted
>> into the known-working kernel, making sure that any fancy power mgmt
>> features were disabled (like aspm), but it still failed in the same way.
>>
>> I'm wondering if it's simply something like the socket has failed, and
>> one or more of the terminals isn't connecting to the card?  Though that
>> would only show problems on card insertion, but I gather the driver is
>> having problems from the moment it detects the controller?
> I don't think it's true that we're having any problems talking to the
> controller other than with a card inserted -- do you see any errors in
> dmesg before inserting a card?
>
> It could indeed be some kind of signal integrity issue.  The easy way to
> investigate that would be to boot Windows and see if it works there, and
> the hard way would be to find a friendly hardware hacker with a nice scope.

I have the original HDD with Windows on it around here somewhere; when I
get the chance I'll switch them around and see what Windows thinks of it
(I guess if its still failing then its a warranty fix).

    J
