Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab1KQC7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 21:59:33 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:47954 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab1KQC7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 21:59:32 -0500
Date: Wed, 16 Nov 2011 21:59:01 -0500 (EST)
Message-Id: <20111116.215901.100218898762260021.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: david.decotigny@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ian.campbell@citrix.com,
        eric.dumazet@gmail.com, jeffrey.t.kirsher@intel.com, jpirko@redhat.com,
        joe@perches.com, szymon@janc.net.pl, rick.jones2@hp.com,
        AAbdulla@nvidia.com, therbert@google.com
Subject: Re: [PATCH net-next v6 3/9] kbuild: document RPS/XPS network
 Kconfig options
From: David Miller <davem@davemloft.net>
In-Reply-To: <1321498443.2885.80.camel@deadeye>
References: <1321485122.2709.55.camel@bwh-desktop>
	<CAG88wWZ853cHkykNbQ+Lqrk_D1p-SCmB0Y29YE6GpSSUORwCxg@mail.gmail.com>
	<1321498443.2885.80.camel@deadeye>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 16 Nov 2011 18:59:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Thu, 17 Nov 2011 02:54:03 +0000

> On Wed, 2011-11-16 at 17:54 -0800, David Decotigny wrote:
>> On Wed, Nov 16, 2011 at 3:12 PM, Ben Hutchings
>> <bhutchings@solarflare.com> wrote:
>> > On Wed, 2011-11-16 at 14:15 -0800, David Decotigny wrote:
>> >> This adds a description of RPS/XPS options and allow them to be
>> >> changed at make menuconfig time.
>> >
>> > I'm not sure why you think this is necessary.
>> 
>> On my copy, make menuconfig doesn't let me change these CONFIG_ items,
>> unless I add the string after "boolean", which this patch does. I
>> agree, the help I added after is pure cosmetic.
> [...]
> 
> I know, but I'm asking why you think it's necessary to make them
> optional.

They shouldn't be, they are internal dependency descriptions and should
be invisible to the user.
