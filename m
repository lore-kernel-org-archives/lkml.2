Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab2CMUg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 16:36:58 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46998 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2CMUg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 16:36:56 -0400
Message-ID: <4F5FAFE4.5090703@pobox.com>
Date: Tue, 13 Mar 2012 16:36:52 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: linux-ide@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Lin Ming <ming.m.lin@intel.com>,
        Norbert Preining <preining@logic.at>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Valdis Kletnieks <valdis.kletnieks@vt.edu>,
        "Rafael J . Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v2 1/3] ahci: add AHCI_HFLAG_DELAY_ENGINE host flag
References: <1329849524-23758-1-git-send-email-computersforpeace@gmail.com> <1329849524-23758-2-git-send-email-computersforpeace@gmail.com>
In-Reply-To: <1329849524-23758-2-git-send-email-computersforpeace@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 01:38 PM, Brian Norris wrote:
> The following commit was intended to fix problems with specific AHCI
> controller(s) that would become bricks if the AHCI specification was not
> followed strictly (that is, if ahci_start_engine() was called while the
> controller was in the wrong state):
>
>      commit 7faa33da9b7add01db9f1ad92c6a5d9145e940a7
>      ahci: start engine only during soft/hard resets
>
> However, some devices currently have issues with that fix, so we must
> implement a flag that delays the ahci_start_engine() call only for specific
> controllers.
>
> This commit simply introduces the flag, without enabling it in any driver.
>
> Note that even when AHCI_HFLAG_DELAY_ENGINE is not enabled, this patch does
> not constitue a full revert to commit 7faa33da; there is still a change in
> behavior to the ahci_port_suspend() failure path.
>
> Signed-off-by: Brian Norris<computersforpeace@gmail.com>

applied 1-3



