Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab1FLRKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 13:10:42 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:53672 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751159Ab1FLRKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 13:10:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAM7y9E1Ld/sX/2dsb2JhbAAMRoRJ212PWoErg2+BCgSZFogX
X-IronPort-AV: E=Sophos;i="4.65,355,1304308800"; 
   d="scan'208";a="116111707"
Message-ID: <4DF4F30B.70702@teksavvy.com>
Date: Sun, 12 Jun 2011 13:10:35 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Bruce Stenning <b.stenning@indigovision.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
References: <20110426135027.GI878@htj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C77554C70@gretna.indigovision.com> <20110426155229.GM878@htj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C77554C91@gretna.indigovision.com> <20110430140109.GJ29280@htj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C777089B2@gretna.indigovision.com> <20110525094127.GF10146@htj.dyndns.org> <4DF20E03.9030502@teksavvy.com> <20110610140155.GJ15235@htj.dyndns.org> <4DF25526.9010800@teksavvy.com> <20110611121957.GA7980@mtj.dyndns.org>
In-Reply-To: <20110611121957.GA7980@mtj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-06-11 08:19 AM, Tejun Heo wrote:
> On Fri, Jun 10, 2011 at 01:32:22PM -0400, Mark Lord wrote:
>>> I don't think it would be wise to include the patch for -stable tho.
>>> It's not a regression fix and has some possibility of introducing
>>> regressions, so....
>>
>> Not a regression fix?  Excuse me?
>> SATA hotplug always used to work fine,
>> and is more or less essential to reboot-free operations.
> 
> There are two separate patches.  One is a fix which got pushed to
> Linus by Jeff early yesterday.  The other changes behavior which has
> been like that since the beginning of EH.  The former is marked
> properly w/ -stable.  The latter shouldn't be in -stable.

Peachy.  Got links for each of those?
I may try them with the sata_sil board that was having issues earlier.

Cheers
