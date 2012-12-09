Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab2LII2B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 03:28:01 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57616 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab2LII17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 03:27:59 -0500
Date: Sun, 9 Dec 2012 08:27:56 +0000
From: Cong Ding <dinggnu@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH v2] arch/x86/tools/gen-insn-attr-x86.awk: remove
 duplicate const
Message-ID: <20121209082755.GB9181@gmail.com>
References: <1354920151-4461-1-git-send-email-dinggnu@gmail.com>
 <3c1e54bc-31ec-4a38-b6d3-58b25760f9cb@email.android.com>
 <20121207224949.GA6179@gmail.com>
 <50C27410.7050101@zytor.com>
 <20121207230302.GB6179@gmail.com>
 <50C27665.4090206@zytor.com>
 <20121207231729.GC6179@gmail.com>
 <50C420A7.9090108@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C420A7.9090108@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2012 at 02:24:55PM +0900, Masami Hiramatsu wrote:
> (2012/12/08 8:17), Cong Ding wrote:
> >>>>>> Patch description please?
> >>>>> there are 2 consts in the definition of one variable
> >>>>>
> >>>>
> >>>> Please put in an actual patch description.  The first line (subject
> >>>> line) is a title; the patch should make sense without it.
> >>> sorry for that. so like this is fine?
> >>>
> >>
> >> Well, except that typically you should explain which variable it is.
> >> Yes, it is obvious if you look at the patch, but you're making the
> >> reader spend a few more moments than necessary.
> >>
> >> Also, you should explain what the harm is -- if it breaks anything
> >> or is just a cosmetic issue.
> > sorry again for lacking of experience...
> > and I missed another same error, so send version 2.
> 
> Ah, sorry for my mistake. I would like to make both the value
> pointed by the pointers and the pointers itself read-only.
> Thus the right way of the patch should be;
> 
> -	print "const insn_attr_t const *inat_escape_tables[INAT_ESC_MAX + 1]" \
> +	print "const insn_attr_t * const inat_escape_tables[INAT_ESC_MAX + 1]" \
> 
> Cong, could you update your patch? then I can Ack that.
Hi Masami, Thank you for the note.

Hi Peter, I have updated and sent version 3, could you please help me update
it?

Thanks,
- cong
