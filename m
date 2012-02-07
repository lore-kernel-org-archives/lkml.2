Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab2BGT2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:28:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61679 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab2BGT2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:28:04 -0500
Message-ID: <4F317B40.3090508@lwfinger.net>
Date: Tue, 07 Feb 2012 13:28:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>, andiry.xu@amd.com
CC: Richard Farina <sidhayn@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Question about error from xhci-hcd
References: <4F30BB0B.5060203@gmail.com> <4F31275A.8000502@lwfinger.net> <20120207145553.GA5235@xanatos>
In-Reply-To: <20120207145553.GA5235@xanatos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 08:55 AM, Sarah Sharp wrote:
>
> They can be caused by any USB driver that attempts to queue large
> transfers or many small transfers.

At least two of the drivers that I maintain, or have had some part of the 
development, have this problem; however, I do not have the hardware to replicate 
it. I am ready to help in any way I can.

Is the ringfull patch that Andiry sent still useful? I know that it applies. If 
it would be worthwhile, I'll send it on to Richard.

Thanks,

Larry

