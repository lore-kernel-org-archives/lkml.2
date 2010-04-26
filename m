Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab0DZKuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 06:50:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490Ab0DZKuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 06:50:12 -0400
Message-ID: <4BD56FD9.7010304@suse.de>
Date: Mon, 26 Apr 2010 16:20:01 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christian Eggers <ceggers@gmx.de>
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: cifs: Filesystem unmounts automatically after some time
References: <201004232148.52739.ceggers@gmx.de>
In-Reply-To: <201004232148.52739.ceggers@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2010 01:18 AM, Christian Eggers wrote:
> # uname -r
> 2.6.34-rc5-desktop
> 
> Samba server: Debian with Samba-3.2.5 (also other OS seem to be affected)
> 
> # modprobe cifs
> # mount -t cifs //server/privat /mnt -o username=christian
> 
> When I mount a remote Samba share with the previous commands, the share gets successfully mounted and is shown in the output of the "mount" command. After some minutes the share is automatically unmounted without any user intervention. Is this a wanted feature 
> or a bug?
> 

I remember seeing a similar bug which was due to buggy version of dhcpcd
and I could never manage to reproduce this with dhclient.

Could you try reproducing the problem with a static IP or using dhclient?

Thanks,

-- 
Suresh Jayaraman
