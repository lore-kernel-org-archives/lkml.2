Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751040Ab2APFRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 00:17:34 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:36038 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750715Ab2APFRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 00:17:32 -0500
Message-ID: <4F13C08F.8040405@xenotime.net>
Date: Sun, 15 Jan 2012 22:15:43 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: Re: linux-next: Tree for Jan 4 (usb/otg)
References: <20120104191656.de575406a93b3c5226c531b2@canb.auug.org.au> <4F04E96F.6040501@xenotime.net>
In-Reply-To: <4F04E96F.6040501@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2012 04:06 PM, Randy Dunlap wrote:
> On 01/04/2012 12:16 AM, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20120103:
> 
> 
> 
> ERROR: "usb_add_hcd" [drivers/usb/otg/mv_otg.ko] undefined!
> ERROR: "usb_remove_hcd" [drivers/usb/otg/mv_otg.ko] undefined!
> 
> 
> Full randconfig file is attached.


This is still a problem in linux-next of 20120116.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
