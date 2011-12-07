Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab1LGK4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 05:56:54 -0500
Received: from mail2.vodafone.ie ([213.233.128.44]:46164 "EHLO
	mail2.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab1LGK4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 05:56:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAHxF305tTAz3/2dsb2JhbAAMN61JAQEBAgEBMgFGBQsLDQEKCRYPCQMCAQIBRQYNAQcBAYgDCLVjizQEmlWMOQ
Message-ID: <4EDF4672.9080705@draigBrady.com>
Date: Wed, 07 Dec 2011 10:56:50 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Lukas Czerner <lczerner@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-lvm@redhat.com, linux-btrfs@vger.kernel.org,
        Ric Wheeler <rwheeler@redhat.com>
Subject: Re: System Storage Manager
References: <alpine.LFD.2.00.1112071055270.4205@dhcp-27-109.brq.redhat.com>
In-Reply-To: <alpine.LFD.2.00.1112071055270.4205@dhcp-27-109.brq.redhat.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2011 10:20 AM, Lukas Czerner wrote:
> Hello everyone,
> 
> I would like to introduce to you a new tool called System Storage
> Manager (ssm). It is supposed to provide easy to use command line
> interface to manage your storage using various technologies like
> lvm, btrfs, encrypted volumes and possibly more.
> 
> Background
> ----------
> 
> In more sophisticated enterprise storage environments, management with
> Device Mapper (dm), Logical Volume Manager (LVM), or Multiple Devices
> (md) is becoming increasingly more difficult. With file systems added
> to the mix, the number of tools needed to configure and manage storage
> has grown so large that it is simply not user friendly. With so many
> options for a system administrator to consider, the opportunity for
> errors and problems is large.

This seems like a worthwhile project given the overlap
in functionality from the various commands.
It echoes some of the functionality provided by libguestfs
for VM images I think.

> The btrfs administration tools have shown us that storage management can
> be simplified, and we are working to bring that ease of use to Linux
> filesystems in general.
> 
> 
> You can also find some more information in my presentation from LinuxCon
> Prague this year:
> 
> http://people.redhat.com/lczerner/files/lczerner_fsm.pdf

This had the name 'fsm'.
I do think 'ssm' is better, however I would drop the '.py' from
the command name. This is incidental and restrictive going forward.
Note I checked the debian and freebsd man pages and 'ssm' is available.

> The code is still under development and no release has been made yet, but
> I would like to share with you what I have done so far, since the
> progress has been a bit slower than I have previously expected. The
> project lives on the sf.net :
> 
> https://sourceforge.net/projects/storagemanager/

This is a much cleaner landing page:
http://sourceforge.net/p/storagemanager/home/Home/

cheers,
Pádraig.
