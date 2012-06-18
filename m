Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab2FRBL4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 21:11:56 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:44332 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363Ab2FRBLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 21:11:55 -0400
Date: Mon, 18 Jun 2012 02:11:51 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: linux-kernel@vger.kernel.org
Cc: Trond.Myklebust@netapp.com
Subject: Re: nfs3 problem with -rc{2,3}
Message-ID: <20120618011151.GA22086@milliways>
References: <20120617200700.GA15348@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120617200700.GA15348@milliways>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=wom5GMh1gUkA:10 a=IxJ0d4kOqokA:10 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=cAj_-RnchIOuiNIcmhIA:9 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 09:07:00PM +0100, Ken Moffat wrote:
>  I'm seeing problems writing to shared directories mounted as nfs3.
> Wondering if anyone else is seeing similar problems ?
> 
[...]
> 
>  I suppose I'll have to start to bisect using the backup script as
> my test case (booted rc2 earlier, did nothing except ssh and allow
> fcron to run it - it stalled.  built rc3, booted that, fcron tried
> to run the incomplete backup, again it has stalled).
> 

 The good news is that the backup script appears to be adequate to
distinguish good and bad kernels : backing up /boot (I have a new
kernel at each stage of bisection, so always something to transfer
with rsync) either works, or appears to transfer something (I see
network activity in my desktop's panel) and then hangs.

 The bad news is that so many of the nfs commits fail to build with
my config (attached to original post).  At the moment I seem to be
stuck at 15 commits to test.  So far I've installed and tested about
eight commits between 3.4 and 3.5-rc2, and failed to build another
seven (three different errors so far).  Enough for tonight, I'll
resume somewhen.

ĸen
