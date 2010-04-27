Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab0D0SrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:47:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:47336 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab0D0Sq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 14:46:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=wIqbqTwgev9e5/RDC3niSn4dITMYAiSX71F60mOFulpTkL4PhCLJ4iBUFVtl02MMzw
         dwQATdOq2mLQ6gmifhPj/m5adJgPYe9/XVsHLwrwLyAAZpDvdKfJIMWT/zSTvWo2eEl5
         nId/1hYMi1s2TMEDUsSFSa7fxU5+B2DxB0nk8=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Nico Schottelius <nico-linux-20100427@schottelius.org>
Subject: Re: 2.6.34-rc4/5: iwlagn unusable until reload
Date: Tue, 27 Apr 2010 20:46:53 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc5; KDE/4.3.4; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20100427074934.GB3261@ikn.schottelius.org>
In-Reply-To: <20100427074934.GB3261@ikn.schottelius.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004272046.53336.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wtorek, 27 kwietnia 2010 o 09:49:34 Nico Schottelius wrote:
> Hello again!
> 
> If I try to use iwlagn on the X201 with
> 
> 02:00.0 Network controller: Intel Corporation WiFi Link 6000 Series (rev
>  35)
> 
> and 2.6.34-rc5-00211-gb91ce4d, I get a lot of error and no connection,
> until I
> 
> [root@kr ~]# rmmod iwlagn
> [root@kr ~]# modprobe iwlagn
> 
> Attached dmesg before & after.
> 
> Cheers,
> 
> Nico
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=15862
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
