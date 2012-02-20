Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab2BTUhC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 15:37:02 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47832 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab2BTUhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 15:37:00 -0500
Message-ID: <4F42AEE9.5070800@pobox.com>
Date: Mon, 20 Feb 2012 15:36:57 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: linux-ide@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Kevin Cernekee <cernekee@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>, Norbert Preining <preining@logic.at>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        "Rafael J . Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 0/3] ahci: fix boot/resume COMRESET failures
References: <1329768563-13715-1-git-send-email-computersforpeace@gmail.com>
In-Reply-To: <1329768563-13715-1-git-send-email-computersforpeace@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2012 03:09 PM, Brian Norris wrote:
> This series addresses regression problems with
>
>      commit 7faa33da9b7add01db9f1ad92c6a5d9145e940a7
>      ahci: start engine only during soft/hard resets
>
> Because the fix provided by the above commit caused COMRESET failures and
> 10 second boot-time/resume-time hangs for certain DVD drives, we need to
> make the fix conditional to certain devices/platforms. Add a flag for this.
>
> Brian
>
> Brian Norris (3):
>    ahci: add AHCI_HFLAG_STRICT_SPEC host flag
>    ahci: move AHCI_HFLAGS() macro to ahci.h
>    ahci_platform: add STRICT_AHCI platform type

Patch series looks good to me.  I'll throw it into the repo today 
(unless any objections arise).

	Jeff




