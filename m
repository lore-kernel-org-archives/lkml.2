Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115Ab0JGHjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 03:39:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49226 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759524Ab0JGHjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 03:39:23 -0400
Date: Thu, 7 Oct 2010 10:39:25 +0300
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
Cc: "Balbi, Felipe" <balbi@ti.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Jiri Kosina <jkosina@suse.cz>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: linux-next: manual merge of the usb tree with the trivial tree
Message-ID: <20101007073925.GE686@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20101006141414.abf7431f.sfr@canb.auug.org.au>
 <20101006061927.GA2659@legolas.emea.dhcp.ti.com>
 <20101006140556.GA19537@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20101006140556.GA19537@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 09:05:56AM -0500, Greg KH wrote:
>On Wed, Oct 06, 2010 at 09:19:27AM +0300, Felipe Balbi wrote:
>> On Tue, Oct 05, 2010 at 10:14:14PM -0500, Stephen Rothwell wrote:
>> >Hi Greg,
>> >
>> >Today's linux-next merge of the usb tree got a conflict in
>> >drivers/usb/musb/musb_gadget.c between commit
>> >7f26b3a7533bbc1ddd88b297c935ee4da8f74cea ("drivers/usb: Remove
>> >unnecessary return's from void functions") from the trivial tree and
>>
>> funny that I wasn't CCed to that one :-(
>
>It was 'trivial' patches, which don't always get sent to the individual
>developer unfortunately.
>
>sorry,

ok, no problem. It would just help avoiding the conflict :-D

-- 
balbi
