Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab2KWHka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:40:30 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38669 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932867Ab2KWHk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:40:28 -0500
Date: Fri, 23 Nov 2012 08:40:23 +0100
From: Michal Hocko <mhocko@suse.cz>
To: azurIt <azurit@pobox.sk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups mailinglist <cgroups@vger.kernel.org>
Subject: Re: memory-cgroup bug
Message-ID: <20121123074023.GA24698@dhcp22.suse.cz>
References: <20121121200207.01068046@pobox.sk>
 <20121122152441.GA9609@dhcp22.suse.cz>
 <20121122190526.390C7A28@pobox.sk>
 <20121122214249.GA20319@dhcp22.suse.cz>
 <20121122233434.3D5E35E6@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121122233434.3D5E35E6@pobox.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 22-11-12 23:34:34, azurIt wrote:
[...]
> >And finally could you post the disassembly of your version of
> >mem_cgroup_handle_oom, please?
> 
> How can i do this?

Either use gdb YOUR_VMLINUX and disassemble mem_cgroup_handle_oom or
use objdump -d YOUR_VMLINUX and copy out only mem_cgroup_handle_oom
function.
-- 
Michal Hocko
SUSE Labs
