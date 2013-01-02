Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404Ab3ABFMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 00:12:23 -0500
Received: from ozlabs.org ([203.10.76.45]:50491 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab3ABFMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 00:12:20 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sam Ravnborg <sam@ravnborg.org>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Michal Marek <mmarek@suse.cz>, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] modpost: Ignore ARC specific non-alloc sections
In-Reply-To: <20121227204816.GA2068@merkur.ravnborg.org>
References: <1352720953-24321-21-git-send-email-vgupta@synopsys.com> <1356605240-4555-1-git-send-email-vgupta@synopsys.com> <1356605240-4555-2-git-send-email-vgupta@synopsys.com> <20121227204816.GA2068@merkur.ravnborg.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 02 Jan 2013 11:19:13 +1030
Message-ID: <8738yk76k6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> writes:

> On Thu, Dec 27, 2012 at 04:17:20PM +0530, Vineet Gupta wrote:
>> ARC relocatable object files contain one/more .gnu.linkonce.arcextmap.*
>> sections (collated by kernel/vmlinux.lds into .arcextmap in final link).
>> This section is used by debuggers to display the extension instructions
>> and need-not be loaded by target (hence !SHF_ALLOC)
>> 
>> The final kernel binary only needs .arcextmap entry in modpost's ignore
>> list (section_white_list[]). However when building modules, modpost scans
>> each object file individually, hence tripping on non-aggregated
>> .gnu.linkonce.arcextmap.* entries as well.
>
> The list exist for this particular purpose.
> So acked.

Applied, thanks!

Cheers,
Rusty.
