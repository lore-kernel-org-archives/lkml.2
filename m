Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0HEEUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 00:20:41 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55653 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab0HEEUh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 00:20:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vJtUMThCqphLzAFU9cP+6ARWhEEes/sJ4At2moc7AJ3GdU2U1O+DZ0MAyZEnYSmlS+
         icOuZdOm6OluO1Ev48rebTVvMWjvLVThEUuiLw4Y82OPos10juAclL/HMwFAhQkfWfsd
         je/vz2IDBZ5MOacsyjN0tzHC+PaUGKjUzyO6M=
MIME-Version: 1.0
In-Reply-To: <1280889274.13192.565.camel@localhost>
References: <20100804001429.6571.95116.stgit@localhost.localdomain>
	<1280889274.13192.565.camel@localhost>
Date: Wed, 4 Aug 2010 21:20:36 -0700
X-Google-Sender-Auth: ruxMxHVa-KV-aAQCQGKV4HD7g4A
Message-ID: <AANLkTimTqMb+n9-v9PDeY2ByN3n2BD_eQfmxJ8ymyuyZ@mail.gmail.com>
Subject: Re: [PATCH 1/2] igb.txt: Add igb documentation
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gospo@redhat.com, bphilips@novell.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0On Tue, Aug 3, 2010 at 19:34, Ben Hutchings <bhutchings@solarflare.com> wrote:
> On Tue, 2010-08-03 at 17:15 -0700, Jeff Kirsher wrote:
> [...]
>> +  Jumbo Frames
>> +  ------------
>> +  Jumbo Frames support is enabled by changing the MTU to a value larger than
>> +  the default of 1500.  Use the ifconfig command to increase the MTU size.
>> +  For example:
>> +
>> +       ifconfig eth<x> mtu 9000 up
>> +
>> +  This setting is not saved across reboots.
>
> Not igb-specific.
>
> [...]
>> +  Ethtool
>> +  -------
>> +  The driver utilizes the ethtool interface for driver configuration and
>> +  diagnostics, as well as displaying statistical information.  Ethtool
>> +  version 3.0 or later is required for this functionality, although we
>> +  strongly recommend downloading the latest version at:
>> +
>> +  http://sourceforge.net/projects/gkernel.
>
> Not igb-specific, and seriously - 3.0?
>
>> +  Enabling Wake on LAN* (WoL)
>> +  ---------------------------
>> +  WoL is configured through the Ethtool* utility.
>
> Not igb-specific.
>
> [...]
>> +  LRO
>> +  ---
>> +  Large Receive Offload (LRO) is a technique for increasing inbound throughput
>> +  of high-bandwidth network connections by reducing CPU overhead. It works by
>> +  aggregating multiple incoming packets from a single stream into a larger
>> +  buffer before they are passed higher up the networking stack, thus reducing
>> +  the number of packets that have to be processed. LRO combines multiple
>> +  Ethernet frames into a single receive in the stack, thereby potentially
>> +  decreasing CPU utilization for receives.
>
> Not igb-specific.
>
>> +  NOTE: LRO requires 2.6.24 or later kernel version.
> [...]
>
> Which is irrelevant to an in-tree driver.
>
> Ben.
>
> --
> Ben Hutchings, Senior Software Engineer, Solarflare Communications
> Not speaking for my employer; that's the marketing department's job.
> They asked us to note that Solarflare product names are trademarked.
>

Thanks for the review Ben.

I am fine and agree with removing the reference to Ethtool version 3.0
and reference to LRO requiring 2.6.24 kernel.  Sorry we did not catch
the earlier...

As far as the 4 sections you noted as not being igb-specific, while
these sections are not specific to the driver, I see them as useful to
users trying to find more information on the driver and how to
configure it.  IMHO more documentation is more useful that too little,
as long as you are not adding bloat to the documentation which makes
it difficult to find what you are looking for.

If I am in minority here, I fine with removing the non-igb specific
sections as well.

-- 
Cheers,
Jeff
