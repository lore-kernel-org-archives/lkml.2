Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab0KTObg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 09:31:36 -0500
Received: from 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com ([207.172.69.77]:59175
	"EHLO thaum.luto.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab0KTObf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 09:31:35 -0500
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Nov 2010 09:31:35 EST
Message-ID: <4CE7DA05.8050605@mit.edu>
Date: Sat, 20 Nov 2010 09:24:05 -0500
From: Andy Lutomirski <luto@mit.edu>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [00/66] 2.6.36.1-stable review
References: <20101119220309.GA15562@kroah.com>
In-Reply-To: <20101119220309.GA15562@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.36.1 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.

Can you add ab838338a2a9e0cb8346eb0cab9977be13e8dce5?  (Somehow the cc: stable got eaten, but 2.6.36 definitely needs this one.  2.6.35 probably does 
as well but I haven't tested it.)

--Andy

> 
> Responses should be made by Monday, November 22, 2010, 12:00:00 UTC
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.36.1-rc1.gz
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> 
