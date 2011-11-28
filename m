Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1K1Vxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 16:53:35 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46300 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab1K1Vxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 16:53:33 -0500
Message-ID: <4ED402D9.1070505@lwfinger.net>
Date: Mon, 28 Nov 2011 15:53:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Andiry Xu <andiry.xu@amd.com>, USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, v4mp <gaigo88@hotmail.it>
Subject: Re: Question about error from xhci-hcd
References: <4EAC3C5C.5000209@lwfinger.net> <20111030050443.GC4535@xanatos> <4EB01904.10605@lwfinger.net> <4EC0DCD5.2010509@amd.com> <20111128181413.GA6462@xanatos>
In-Reply-To: <20111128181413.GA6462@xanatos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2011 12:14 PM, Sarah Sharp wrote:
> Ping.  Larry, have you been able to test Andiry's patch?  We'd like to
> figure out what's wrong with the control endpoint ring in your xHCI host.

Sarah,

So far, the OP has not yet gotten a run that includes the extra output that 
Andiry's patch provides, and I have not yet figured out why. He cannot build his 
own kerne;, thus I have had to get the revised copy of xhci-hcd folded into the 
compat-wireless source. That seems to be working, but still no output.

Thanks,

Larry



