Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab3AHLqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:46:24 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:64858 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab3AHLqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:46:22 -0500
Message-ID: <50EC070C.2090101@suse.cz>
Date: Tue, 08 Jan 2013 12:46:20 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>
CC: Borislav Petkov <bp@alien8.de>, Shane Huang <Shane.Huang@amd.com>,
        Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ata1: COMRESET failed
References: <508A7A8A.7030908@suse.cz> <50BC8A1C.8070805@suse.cz> <20121203115734.GA32243@liondog.tnic> <20130107172425.GD5954@liondog.tnic> <50EB770A.4090302@intel.com>
In-Reply-To: <50EB770A.4090302@intel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 02:31 AM, Aaron Lu wrote:
> On 01/08/2013 01:24 AM, Borislav Petkov wrote:
>> Adding some more people.
>>
>> Aaron, Shane, do you guys have any ideas? I've been seeing something
>> similar on an AMD desktop box recently and Jiri sees it on a laptop with
>> an SSD.
> 
> I've seen a similar problem on a bug report recently for a Crucial SSD,
> and upgrading the disk's firmware fixed the problem:
> https://bugzilla.kernel.org/show_bug.cgi?id=49701
> 
> If the controller has problem, it should have problems for all kinds of
> disks attached to it. So possible to test with other disks, Jiri?

Yes, I tested a normal spinning disk and it does not happen with that.
This happens only with this Intel SSD: SSDSA2M080G2GC

So I will try to investigate how to upgrade the firmware and will report.

thakns,
-- 
js
suse labs
