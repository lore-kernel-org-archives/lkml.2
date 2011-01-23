Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab1AWUYv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 15:24:51 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:48438 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab1AWUYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 15:24:50 -0500
Message-ID: <4D3C8E90.6010506@pardus.org.tr>
Date: Sun, 23 Jan 2011 22:24:48 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, rjw@sisk.pl,
        colin.king@canonical.com
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus
 laptops)
References: <4D3C3B1E.1080500@pardus.org.tr>
In-Reply-To: <4D3C3B1E.1080500@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.01.2011 16:28, Ozan Çağlayan wrote:
> Hi,
>
> I'm getting a lot of bug reports about hanging boot/shutdowns on these
> days.
>
> Most of the affected hardware are ASUS laptops. The problem is that I
> don't have access to any of those problematic laptops and the users are
> not able at all to debug/bisect what is going on. However, I have
> collected dmesgs of good/bad boots, acpidump, etc.
>
> Here are the current status:
>
> "Asus F50SV does not boot unless lapic is passed"
> https://bugzilla.kernel.org/show_bug.cgi?id=26502
>
> "Regression between 2.6.35-020635-rc1 and 2.6.35-020635 breaks acpi
> support on Asus X71 laptop"
> https://bugs.launchpad.net/ubuntu/+source/linux-meta/+bug/689796
>
> "Asus N61JQ hangs at shutdown unless lapic is passed"
> (Not reported upstream yet, I've only downstream bug report which is
> Turkish)
> http://bugs.pardus.org.tr/show_bug.cgi?id=15969
>
> "Asus X61S does not boot unless acpi=off is given"
> (Not reported upstream yet, I've only downstream bug report which is
> Turkish)
> http://bugs.pardus.org.tr/show_bug.cgi?id=16322
> (I've told the reporter to try with nolapic, it will probably fix the
> issue but until confirmed acpi=off is the only solution. 2.6.36 was fine)
>
> I'll post more bugs in here as I've found them.

(CC'ing: Colin King from Canonical)

Another one for Asus N90Sc which was booting fine with 10.04
but fails to boot with 10.10:
  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/653626

Seen that the issue mostly happens on Asus boxes, it's possible
that their firmwares are buggy but they were booting/shutting down
correctly until a recent change in kernel.


-- 
Pardus Linux
http://www.pardus.org.tr/eng
