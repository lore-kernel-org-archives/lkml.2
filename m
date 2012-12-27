Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab2L0UsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 15:48:21 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:42436 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2L0UsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 15:48:19 -0500
Date: Thu, 27 Dec 2012 21:48:16 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Michal Marek <mmarek@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] modpost: Ignore ARC specific non-alloc sections
Message-ID: <20121227204816.GA2068@merkur.ravnborg.org>
References: <1352720953-24321-21-git-send-email-vgupta@synopsys.com> <1356605240-4555-1-git-send-email-vgupta@synopsys.com> <1356605240-4555-2-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356605240-4555-2-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 04:17:20PM +0530, Vineet Gupta wrote:
> ARC relocatable object files contain one/more .gnu.linkonce.arcextmap.*
> sections (collated by kernel/vmlinux.lds into .arcextmap in final link).
> This section is used by debuggers to display the extension instructions
> and need-not be loaded by target (hence !SHF_ALLOC)
> 
> The final kernel binary only needs .arcextmap entry in modpost's ignore
> list (section_white_list[]). However when building modules, modpost scans
> each object file individually, hence tripping on non-aggregated
> .gnu.linkonce.arcextmap.* entries as well.

The list exist for this particular purpose.
So acked.

> 
> Thus need for the 2 entires !
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>


	Sam
