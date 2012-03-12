Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab2CLWMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:12:18 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33482 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574Ab2CLWMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:12:15 -0400
Date: Mon, 12 Mar 2012 15:12:09 -0700
From: Tejun Heo <tj@kernel.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Lin Ming <ming.m.lin@intel.com>, Norbert Preining <preining@logic.at>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        "Rafael J . Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v2 0/3] ahci: fix boot/resume COMRESET failures
Message-ID: <20120312221209.GH23255@google.com>
References: <1329849524-23758-1-git-send-email-computersforpeace@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329849524-23758-1-git-send-email-computersforpeace@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 10:38:41AM -0800, Brian Norris wrote:
> This series addresses regression problems with
> 
>     commit 7faa33da9b7add01db9f1ad92c6a5d9145e940a7
>     ahci: start engine only during soft/hard resets
> 
> Because the fix provided by the above commit caused COMRESET failures and
> 10 second boot-time/resume-time hangs for certain DVD drives, we need to
> make the fix conditional to certain devices/platforms. Add a flag for this.
> 
> Brian
> 
> v2: change flag name to AHCI_HFLAG_DELAY_ENGINE, write more detailed
>     comments
> 
> v1: flag named AHCI_HFLAG_STRICT_SPEC
> 
> Brian Norris (3):
>   ahci: add AHCI_HFLAG_DELAY_ENGINE host flag
>   ahci: move AHCI_HFLAGS() macro to ahci.h
>   ahci_platform: add STRICT_AHCI platform type

This looks good to me.  Jeff?

-- 
tejun
