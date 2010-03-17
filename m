Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab0CQPHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 11:07:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab0CQPHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 11:07:49 -0400
Message-ID: <4BA0F057.7020909@redhat.com>
Date: Wed, 17 Mar 2010 11:08:07 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ric Wheeler <rwheeler@redhat.com>, Tejun Heo <tj@kernel.org>,
       James Bottomley <James.Bottomley@suse.de>,
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
References: <6af388e7-e313-4212-86c8-30ffa327411c@email.android.com>
In-Reply-To: <6af388e7-e313-4212-86c8-30ffa327411c@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 06:21 PM, H. Peter Anvin wrote:
> The only reason I see to care about CHS at all is that there are systems in the field which can only boot from USB in CHS mode, and which often look at the MBR partition table to guess the geometry.  Of course, some then *report* the detected geometry but don't *use* the detected geometry...
>
>    

These systems, given the changes in modern microsoft releases, must be 
doomed even without any effort on our part.

I still think that we should work to make this ancient stuff disappear & 
help force the legacy edge cases to modernize. It has been some huge 
amount of time since storage vendors pretty much abandoned CHS (15 
years? 20?) :-)

ric

