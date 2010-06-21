Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab0FUNwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 09:52:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:57366 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab0FUNwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 09:52:09 -0400
Message-ID: <4C1F6E5D.5030809@kernel.org>
Date: Mon, 21 Jun 2010 15:51:25 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Subject: Re: [PATCH 12/12] usb: use IRQ watching
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-13-git-send-email-tj@kernel.org>
In-Reply-To: <1276443098-20653-13-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 21 Jun 2010 13:51:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2010 05:31 PM, Tejun Heo wrote:
> Ask IRQ subsystem to watch HCD IRQ line after initialization.  This at
> least keeps USB ports which are occupied on initialization working and
> eases bug reporting and debugging.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Greg, if you think the change is okay, can you please ack it?  Also,
would it be okay to route this through irq tree?

Thanks.

-- 
tejun
