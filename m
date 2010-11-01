Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab0KAMEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 08:04:52 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36319 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab0KAMEu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 08:04:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=hVFSDp4do5rTR1OTaLKFcHyjAVVBj+LBDoqd2TFToBuwqjpvRIpIOj83eFvtbejgGh
         lJcMrFKDqnt9ZR+ZmSspJJtUuzZmD8WZN638xrhCB/OD+Na/BJNTf0ssoj+r5qRNThEw
         wlqVzgmDjI3Qy5OpDxWquxrZNBc/GEMUfjdpM=
MIME-Version: 1.0
In-Reply-To: <20101101051734.GB17587@angua.secretlab.ca>
References: <1288130833-16421-1-git-send-email-ddaney@caviumnetworks.com> <20101101051734.GB17587@angua.secretlab.ca>
From: Timur Tabi <timur@freescale.com>
Date: Mon, 1 Nov 2010 07:04:17 -0500
X-Google-Sender-Auth: VI9oJ3aCdTzsbwYSyjoewVGYw3U
Message-ID: <AANLkTinTuizm6pij_GWkCqDDH0qRFS6j5ZRzTUJFF_7O@mail.gmail.com>
Subject: Re: [PATCH] OF device tree: Move of_get_mac_address() to a common
 source file.
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
        microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 12:17 AM, Grant Likely <grant.likely@secretlab.ca> wrote:

>> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
>> Cc: Michal Simek <monstr@monstr.eu>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Wolfram Sang <w.sang@pengutronix.de>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Corey Minyard <cminyard@mvista.com>
>> Cc: Pantelis Antoniou <pantelis.antoniou@gmail.com>
>> Cc: Vitaly Bordug <vbordug@ru.mvista.com>
>> Cc: Anatolij Gustschin <agust@denx.de>
>> Cc: John Rigby <jcrigby@gmail.com>
>> Cc: Wolfgang Denk <wd@denx.de>
>> Cc: Anton Vorontsov <avorontsov@mvista.com>
>> Cc: Sandeep Gopalpet <Sandeep.Kumar@freescale.com>
>> Cc: Kumar Gala <galak@kernel.crashing.org>
>> Cc: Li Yang <leoli@freescale.com>
>> Cc: Sergey Matyukevich <geomatsi@gmail.com>
>> Cc: Jiri Pirko <jpirko@redhat.com>
>> Cc: Eric Dumazet <eric.dumazet@gmail.com>
>> Cc: Sean MacLennan <smaclennan@pikatech.com>
>> Cc: Sadanand Mutyala <Sadanand.Mutyala@xilinx.com>
>> Cc: Andres Salomon <dilinger@queued.net>
>> Cc: microblaze-uclinux@itee.uq.edu.au
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linuxppc-dev@lists.ozlabs.org
>> Cc: netdev@vger.kernel.org
>> Cc: devicetree-discuss@lists.ozlabs.org
>
> You don't need to believe everything that get_maintainers is telling
> you.  When you get a large list like this, don't Cc everyone, but
> apply some educated guesses.  You can guess that the PowerPC and
> Microblaze maintainers care because it touches their trees, and you
> can guess that I care because I'm the dt maintainer. David Miller
> isn't a bad guess because of networking.  But 22 people is excessive.

And ironically, he left out the person who wrote the function -- me.

-- 
Timur Tabi
Linux kernel developer at Freescale
