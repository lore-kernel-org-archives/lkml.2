Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab1HaXPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 19:15:13 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:57014 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1HaXPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 19:15:09 -0400
Date: Wed, 31 Aug 2011 19:11:39 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: Re: Hyper-V TODO file
In-reply-to: <1314829011-28922-1-git-send-email-kys@microsoft.com>
Message-id: <alpine.LNX.2.00.1108311907130.20924@linux>
References: <1314829011-28922-1-git-send-email-kys@microsoft.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Aug 2011, K. Y. Srinivasan wrote:
> Greg, as I have been pestering you for some time now, we are very interested in
> exiting staging and we are willing to dedicate the necessary development 
> resources to address whatever issues that may still be pending. So, your help
> in identifying what needs to be done will be greatly appreciated. To that end,
> I think it will be useful to update the TODO file to reflect the current state of
> the drivers. Let us know how we should proceed here. 
 
An issue I've come across in the hyper-v drivers is the forced modular 
build. You might want to see if the "depends on m" is still needed.

Thanks,

Peter Foley
