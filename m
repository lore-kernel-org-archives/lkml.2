Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab2GXNPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 09:15:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:21644 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001Ab2GXNPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 09:15:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="170704158"
Date: Tue, 24 Jul 2012 16:15:27 +0300
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Masatake YAMATO <yamato@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH v3 1/8] bluetooth: /proc/net/ entries for bluetooth
 protocols
Message-ID: <20120724131520.GC11981@aemeltch-MOBL1>
Mail-Followup-To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	Masatake YAMATO <yamato@redhat.com>, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
References: <20120629.020253.963694178693689545.yamato@redhat.com>
 <20120710140400.GA15795@aemeltch-MOBL1>
 <20120711.135831.1712662939552441872.yamato@redhat.com>
 <20120724.220831.1797978247249215593.yamato@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120724.220831.1797978247249215593.yamato@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masatake,

On Tue, Jul 24, 2012 at 10:08:31PM +0900, Masatake YAMATO wrote:
> (I have got no reply since 11th Jul. So I resend this mail here.
>  Please, review this patch and merge it if no problem.)
> 
> (The patch sets are rebased to bluetooth-next. Unnecessary white
>  spaces are trimmed.)
> 
> lsof command can tell the type of socket processes are using.
> Internal lsof uses inode numbers on socket fs to resolve the type of
> sockets. Files under /proc/net/, such as tcp, udp, unix, etc provides
> such inode information.
> 
> Unfortunately bluetooth related protocols don't provide such inode
> information. This patch series introduces /proc/net files for the protocols.
> 
> This patch against af_bluetooth.c provides facility to the implementation
> of protocols. This patch extends bt_sock_list and introduces two exported
> function bt_procfs_init, bt_procfs_cleanup.
> 
> The type bt_sock_list is already used in some of implementation of
> protocols. bt_procfs_init prepare seq_operations which converts
> protocol own bt_sock_list data to protocol own proc entry when the
> entry is accessed.
> 
> What I, lsof user, need is just inode number of bluetooth
> socket. However, people may want more information. The bt_procfs_init
> takes a function pointer for customizing the show handler of
> seq_operations.
>  
> Signed-off-by: Masatake YAMATO <yamato@redhat.com>

Tested-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com> 

Best regards 
Andrei Emeltchenko 
