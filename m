Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab1AaSZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:25:39 -0500
Received: from claw.goop.org ([74.207.240.146]:48854 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573Ab1AaSZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:25:38 -0500
Message-ID: <4D46FE9E.3010502@goop.org>
Date: Mon, 31 Jan 2011 10:25:34 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 31
References: <20110131174113.8199f901.sfr@canb.auug.org.au> <20110131170506.GA11939@dumpdata.com>
In-Reply-To: <20110131170506.GA11939@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 09:05 AM, Konrad Rzeszutek Wilk wrote:
> On Mon, Jan 31, 2011 at 05:41:13PM +1100, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20110121:
>>
>> New tree: unicore32
>>
>> Renamed tree: swiotlb-xen to xen-two
> Sweet. Thank you.
>> Dropped tree: xen
> Uh, why? Jeremy's tree should be OK now? Did something not
> compile correctly? 

No, keep it dropped for now.  I'll do a proper linux-next branch shortly.

    J
