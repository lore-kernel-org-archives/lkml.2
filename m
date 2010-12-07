Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab0LGFts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 00:49:48 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:54125 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198Ab0LGFtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 00:49:47 -0500
Date: Tue, 7 Dec 2010 07:49:42 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bob Liu <lliubbo@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Felipe Balbi <balbi@ti.com>,
        Hema Kalliguddi <hemahk@ti.com>
Subject: Re: linux-next: manual merge of the usb tree with Linus'  tree
Message-ID: <20101207054942.GA2576@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20101206124718.12e49789.sfr@canb.auug.org.au>
 <20101207044358.GB29457@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20101207044358.GB29457@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 08:43:58PM -0800, Greg KH wrote:
>On Mon, Dec 06, 2010 at 12:47:18PM +1100, Stephen Rothwell wrote:
>> Hi Greg,
>>
>> Today's linux-next merge of the usb tree got a conflict in
>> drivers/usb/musb/blackfin.c between commit
>> 1e393c6eece048052d4131ec4dad3b98e35a98e2 ("USB: musb: blackfin: pm: make
>> it work") from Linus' tree and commit
>> ea65df57c2eea803535a071752efb030c46a11f5 ("usb: musb: remove board_data
>> parameter from musb_platform_init()") from the usb tree.
>>
>> I fixed it up (see below) and can carry the fix as necessary.
>
>Thanks.  Felipe, does this patch look correct?  I should probably merge
>the next -rc release into my USB tree to handle this type of thing.

Looks perfect. Thanks Stephen.

-- 
balbi
