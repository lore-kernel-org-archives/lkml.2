Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992513Ab2JYRni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:43:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51270 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050Ab2JYRnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:43:35 -0400
Date: Thu, 25 Oct 2012 10:43:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>
Subject: Re: [RFC 3/3] libata: don't perform HW activity in devres
Message-ID: <20121025174331.GK11442@htj.dyndns.org>
References: <1351184161-31433-1-git-send-email-computersforpeace@gmail.com>
 <1351184161-31433-4-git-send-email-computersforpeace@gmail.com>
 <20121025172542.GG11442@htj.dyndns.org>
 <CAN8TOE_DThBeGvHN9HQtX3CDLuiWDJEVZNKFqRnnOmP=xHN8XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN8TOE_DThBeGvHN9HQtX3CDLuiWDJEVZNKFqRnnOmP=xHN8XQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 25, 2012 at 10:41:57AM -0700, Brian Norris wrote:
> Hmm, I guess that makes more sense. I was using the ahci_platform
> ahci_platform_data->exit() function. Would it be safe to call the
> platform init()/exit() functions as part of a
> ata_port_operations.host_{start,stop}() hook? These functions aren't
> currently implemented at all in ahci_platform, but I don't see why
> they couldn't be.

I don't have much idea about the specifics but host_start/stop() are
supposed to perform the functions you're describing.

Thanks.

-- 
tejun
