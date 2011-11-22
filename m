Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab1KVVNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:13:43 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57044 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab1KVVNl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:13:41 -0500
MIME-Version: 1.0
In-Reply-To: <1321994813.2304.90.camel@jtkirshe-mobl>
References: <cover.1321989502.git.david.decotigny@google.com> <1321994813.2304.90.camel@jtkirshe-mobl>
From: David Decotigny <david.decotigny@google.com>
Date: Tue, 22 Nov 2011 13:13:19 -0800
Message-ID: <CAG88wWY_6o_1Ecxe6+XiA8ga6+t4ua+L6fZ8AOOFyrKgZ8LDMQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/4] e1000e: ethtool setfeatures fixes + loopback
To: jeffrey.t.kirsher@intel.com
Cc: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mahesh Bandewar <maheshb@google.com>,
        =?ISO-8859-2?Q?Maciej_=AFenczykowski?= <maze@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff, Bruce,

Please drop this patch series as I was informed that:
 - http://patchwork.ozlabs.org/patch/95175/ already implemented
loopback for ethtool and is under review. Please note, though, that
the version (patch 2) I submitted builds on top of newer net-next
changes
 - Maciej Żenczykowski would prefer not to use the version I sent for
patches 3 and 4, and will provide an improved patch

I will mark the series as rejected on patchwork and will resend patch
1 (fix) as "v3".

My apologies for this hick-up.

Regards,

--
David Decotigny



On Tue, Nov 22, 2011 at 12:46 PM, Jeff Kirsher
<jeffrey.t.kirsher@intel.com> wrote:
> On Tue, 2011-11-22 at 11:23 -0800, David Decotigny wrote:
>> This series fixes a bug in ethtool setfeatures and adds loopback
>> support through ethtool setfeatures.
>>
>> I believe these patches could easily be adapted to e1000, but I don't
>> have the hardware to test.
>>
>> Changes since v1:
>>   - simplification in patch 1/4 (from Michał Mirosław)
>>
>> ############################################
>> # Patch Set Summary:
>>
>> David Decotigny (2):
>>   net-e1000e: fix ethtool set_features taking new features into account
>>     too late
>>   net-e1000e: ethtool loopback support
>>
>> Maciej Żenczykowski (2):
>>   net-e1000e: reworked carrier detection logic
>>   net-e1000e: Report carrier in loopback mode
>>
>>  drivers/net/ethernet/intel/e1000e/e1000.h   |    2 +
>>  drivers/net/ethernet/intel/e1000e/ethtool.c |    6 +-
>>  drivers/net/ethernet/intel/e1000e/netdev.c  |   32 +++++++++++-
>>  drivers/net/ethernet/intel/e1000e/phy.c     |   69 +++++++++++++++++----------
>>  4 files changed, 78 insertions(+), 31 deletions(-)
>>
>
> Thanks David for the patch set.  I have added the e1000e patches to my
> queue.  As an fyi, I want Bruce Allan to look over these patches and he
> is out this week on vacation.
