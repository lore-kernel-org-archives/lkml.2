Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab2ADRlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:41:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65431 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431Ab2ADRk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:40:58 -0500
Message-ID: <4F048F26.5000804@lwfinger.net>
Date: Wed, 04 Jan 2012 11:40:54 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-01-04
References: <20120104155816.GE2540@tuxdriver.com> <20120104163109.GF2540@tuxdriver.com>
In-Reply-To: <20120104163109.GF2540@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2012 10:31 AM, John W. Linville wrote:
> On Wed, Jan 04, 2012 at 10:58:16AM -0500, John W. Linville wrote:
>
>> I was hesitant to include the rtlwifi fix, but settled on inclusion
>> because it was a product of a recent ginormous thread about the
>> intersection of firmware loading and suspend/resume.  Plus it fixes
>> a bug report in the Red Hat Bugzilla. :-) If you don't think it is
>> worthy, let me know and I'll drop it from this release.
>
> It looks like this could generate a build warning...
>
> 	http://marc.info/?l=linux-wireless&m=132569396407866&w=2
>
> I'm getting cold feet on this one.  I withdraw this pull request --
> new one to follow soon!

John,

I will resubmit this patch with a fix.

I now realize that my fix has a different problem in that the firmware might not 
be preserved under certain scenarios if there were two instances of the device 
sharing the driver. These are corner cases, but I would like to fix that as well.

Is there any way for a driver to know that it is being initialized for a second 
device?

Thanks,

Larry
