Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab0CQRPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 13:15:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47656 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab0CQRPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 13:15:00 -0400
Message-ID: <4BA10DCF.3050901@zytor.com>
Date: Wed, 17 Mar 2010 10:13:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ric Wheeler <rwheeler@redhat.com>
CC: Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@suse.de>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Arnd Bergmann <arnd@arndb.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <6af388e7-e313-4212-86c8-30ffa327411c@email.android.com> <4BA0F057.7020909@redhat.com>
In-Reply-To: <4BA0F057.7020909@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 08:08 AM, Ric Wheeler wrote:
> On 03/16/2010 06:21 PM, H. Peter Anvin wrote:
>> The only reason I see to care about CHS at all is that there are
>> systems in the field which can only boot from USB in CHS mode, and
>> which often look at the MBR partition table to guess the geometry. Of
>> course, some then *report* the detected geometry but don't *use* the
>> detected geometry...
>
> These systems, given the changes in modern microsoft releases, must be
> doomed even without any effort on our part.
>
> I still think that we should work to make this ancient stuff disappear &
> help force the legacy edge cases to modernize. It has been some huge
> amount of time since storage vendors pretty much abandoned CHS (15
> years? 20?) :-)
>

I wish.  This is mostly systems from the first half of the 2000's 
timeframe.  There was a *huge* regression when BIOS vendors started 
doing USB boot; almost all of them introduced major bugs at that time; 
in many cases they still haven't been fixed.

	-hpa
