Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab2JZALT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:11:19 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:39609 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab2JZALQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:11:16 -0400
Message-ID: <5089D520.6020106@gmail.com>
Date: Thu, 25 Oct 2012 20:11:12 -0400
From: Ric Wheeler <ricwheeler@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>, "Ted Ts'o" <tytso@mit.edu>
CC: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
        Bryan Schumaker <bjschuma@netapp.com>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
References: <87objupjlr.fsf@spindle.srvr.nix> <20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix> <20121023143019.GA3040@fieldses.org> <874nllxi7e.fsf_-_@spindle.srvr.nix> <87pq48nbyz.fsf_-_@spindle.srvr.nix> <508740B2.2030401@redhat.com> <87txtkld4h.fsf@spindle.srvr.nix>
In-Reply-To: <87txtkld4h.fsf@spindle.srvr.nix>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 12:15 AM, Nix wrote:
> On 24 Oct 2012, Eric Sandeen uttered the following:
>
>> On 10/23/12 3:57 PM, Nix wrote:
>>> The only unusual thing about the filesystems on this machine are that
>>> they have hardware RAID-5 (using the Areca driver), so I'm mounting with
>>> 'nobarrier':
>> I should have read more.  :(  More questions follow:
>>
>> * Does the Areca have a battery backed write cache?
> Yes (though I'm not powering off, just rebooting). Battery at 100% and
> happy, though the lack of power-off means it's not actually getting
> used, since the cache is obviously mains-backed as well.

Sending this just to you two to avoid embarrassing myself if I misread the 
thread, but....

Can we reproduce this with any other hardware RAID card? Or with MD?

If we cannot reproduce this in other machines, why assume this is an ext4 issue 
and not a hardware firmware bug?

As an ex-storage guy, this really smells like the hardware raid card might be 
misleading us....

ric



