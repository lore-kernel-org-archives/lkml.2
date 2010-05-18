Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab0ERWQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 18:16:55 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49723 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab0ERWQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 18:16:52 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTil4MIKUrzK-SOS9satdcL34F5B_3D6ddFn6lThL@mail.gmail.com>
References: <20100518174750.cc965d84.sfr@canb.auug.org.au> 
	<AANLkTil4MIKUrzK-SOS9satdcL34F5B_3D6ddFn6lThL@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 18 May 2010 16:16:30 -0600
X-Google-Sender-Auth: nfduNrYuEmuv6a4Aqv7B4YVVfhs
Message-ID: <AANLkTik0G8QXBrqbJXwylJOE1QoSzGe4yixUrTenYtdO@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree 
	(devicetree tree related)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 5:52 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Tue, May 18, 2010 at 1:47 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi Grant,
>>
>> After merging the final tree, yesterday's linux-next build (powerpc
>> mpc85xx_defconfig) failed like this:
>>
>> http://kisskb.ellerman.id.au/kisskb/buildresult/2615202/
>>
>> I suspect that is something to do with the devicetree tree.
>
> Ah, yes.  I'll push out fixes for those this morning.

Fixed tree pushed out.

g.
