Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab2KFPUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 10:20:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab2KFPUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 10:20:07 -0500
Date: Tue, 6 Nov 2012 16:19:56 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Chris Friesen <chris.friesen@genband.com>
Cc: Florian Weimer <fw@deneb.enyo.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Eric Paris <eparis@parisplace.org>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
In-Reply-To: <50992946.4060101@genband.com>
Message-ID: <alpine.LNX.2.00.1211061616310.24253@pobox.suse.cz>
References: <20121104135251.GA17894@srcf.ucam.org> <87d2zsmv8r.fsf@xmission.com> <509766DB.9090906@zytor.com> <87625kh5r2.fsf@xmission.com> <20121105123858.GB4374@srcf.ucam.org> <87sj8nc137.fsf@xmission.com> <20121105202557.GA16076@srcf.ucam.org>
 <87hap3zbw7.fsf@xmission.com> <20121106031219.GB24235@srcf.ucam.org> <87fw4nv1vj.fsf@xmission.com> <20121106035352.GA24698@srcf.ucam.org> <87hap3s3yl.fsf@xmission.com> <878vafqi5q.fsf@mid.deneb.enyo.de> <50992946.4060101@genband.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2012, Chris Friesen wrote:

> > Personally, I think the only way out of this mess is to teach users
> > how to disable Secure Boot.
> 
> If you're going to go that far, why not just get them to install a RedHat (or
> SuSE, or Ubuntu, or whoever) key and use that instead?

You always need to keep in mind the possibility of the key being revoked.

> Secure boot does arguably solve a class of problems, so it seems a bit odd to
> recommend just throwing it out entirely.

Not really. It doesn't solve the the most usual attack vector used (i.e. 
exploiting the bug in the kernel ... and that's independent of the OS we 
are talking about).

Just because it contains "secure" in its name, doesn't really make it a 
proper security solution. It should rather be called "vendor lock-in 
boot", or something like that.

-- 
Jiri Kosina
SUSE Labs
