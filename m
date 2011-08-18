Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab1HRSx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 14:53:27 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:37166 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab1HRSx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 14:53:26 -0400
Message-ID: <4E4D5F85.7000503@kernel.org>
Date: Thu, 18 Aug 2011 11:52:53 -0700
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org
Subject: Re: [kernel.org users] [KORG] Taking hera down to deal with the load
 issues
References: <4E4AFCFC.9020008@kernel.org> <4E4B7664.9070301@kernel.org> <20110817183722.GH9959@quack.suse.cz>
In-Reply-To: <20110817183722.GH9959@quack.suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 18 Aug 2011 11:53:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2011 11:37 AM, Jan Kara wrote:
>   Hi,
> 
> On Wed 17-08-11 01:05:56, J.H. wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>> This second kernel is at least, so far, acting a lot closer to what I'd
>> expect from hera, but the disk cache is still filling.  I'm going to
>> keep an eye on it for a bit longer tonight.  As a note, the only
>> difference between the first 3.1-rc1 kernel and the second, that is
>> currently running, was the explicit disabling of IMA and recompiling the
>> kernel.
>   What do you exactly mean by "disk cache is still filling"? 3.1-rc1 has
> quite some changes in writeback code so it's possible something went
> wrong...

Mostly that it takes time to read the bits off of the spinning rust and
have it cached into memory.  Not specifically that there's something
wrong with the writeback, I'm at least not seeing one I believe.

- John 'Warthog9' Hawley
