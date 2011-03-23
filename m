Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab1CWRke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:40:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38908 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab1CWRkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:40:31 -0400
Date: Wed, 23 Mar 2011 17:40:15 +0000
From: Matthew Garrett <mjg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Len Brown <lenb@kernel.org>, Cong Wang <amwang@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        Takao Indoh <tindoh@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        linux-doc@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch] acpi: introduce "acpi_addr=" parameter for kdump
Message-ID: <20110323174015.GA6953@srcf.ucam.org>
References: <1299766243-494-1-git-send-email-amwang@redhat.com> <20110310082600.b52de7fb.rdunlap@xenotime.net> <4D86F3A7.8060706@redhat.com> <alpine.LFD.2.02.1103230026170.10549@x980> <m1lj06zc4u.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1lj06zc4u.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 09:36:33PM -0700, Eric W. Biederman wrote:
> Len Brown <lenb@kernel.org> writes:
> > This should also be [KEXEC], and the code should be #ifdef CONFIG_KEXEC
> > so that sane people can exclude it from their kernels.
> 
> So far sane people don't use EFI on x86 so that is easy enough.

This year's Lenovos and Dells (at least) boot EFI by default. While I'd 
love to see everybody involved in EFI be relocated to a single small 
island without any ability to communicate with the rest of the world, 
it's unfortunately a reality and we have to deal with it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
