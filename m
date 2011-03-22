Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1CVQu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 12:50:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58566 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab1CVQuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 12:50:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Oren Weil <oren.jer.weil@intel.com>
Subject: Re: [PATCH 0/7] char/mei: Intel MEI Driver
Date: Tue, 22 Mar 2011 17:50:51 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, alan@linux.intel.com,
        david@woodhou.se
References: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com>
In-Reply-To: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103221750.52118.arnd@arndb.de>
X-Provags-ID: V02:K0:HpVV0+/MwXzV+keWMNWp0RIbq2gzfPA4XzJKzTWeD1l
 y92yFa4BUiC5paMuuVJzGDPRXyIXEFROeEQy3aOXXgzYHjV3ma
 5leb6qjQf6sDBuOz4ZMcpw3Cfhsf6Cs1uHph9xORza4wwHvSjq
 BJpchHcW0r4251XdlC+0n7kZZX+rdRhjey84XxLvHHOAcTZvRI
 wZwRzd3tTHv9YCpG7yyfg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 March 2011, Oren Weil wrote:
> Module Parameters
> =================
> watchdog_timeout - in order to change the watchdog timeout setting 
> the user can use this module parameter.
> this value set the Intel AMT watchdog timeout interval in seconds, 
> the default value is 120sec.
> to disable the watchdog set the value 0.
> 
> The AMT watchdog is used for monitoring the OS health. 
> 
> Note: We are aware that this code is not in its best shape
> we are working to make it better and we will appreciate any feedbacks 
> and reviews that you can give to improve it.

I suppose one of the important things to do here is integrate
the watchdog part into the common watchdog infrastructure
in drivers/watchdog. Maybe this driver can export a simple
interface to another module that implements the watchdog
device?

	Arnd
