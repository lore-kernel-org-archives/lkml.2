Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab2KFNSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 08:18:13 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:57265 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab2KFNSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 08:18:11 -0500
Date: Tue, 6 Nov 2012 13:17:44 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121106131743.GB1818@srcf.ucam.org>
References: <509766DB.9090906@zytor.com>
 <87625kh5r2.fsf@xmission.com>
 <20121105123858.GB4374@srcf.ucam.org>
 <87sj8nc137.fsf@xmission.com>
 <20121105202557.GA16076@srcf.ucam.org>
 <87hap3zbw7.fsf@xmission.com>
 <20121106031219.GB24235@srcf.ucam.org>
 <87fw4nv1vj.fsf@xmission.com>
 <20121106035352.GA24698@srcf.ucam.org>
 <20121106091217.4a5240f0@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121106091217.4a5240f0@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 09:12:17AM +0000, Alan Cox wrote:
> - is it worth Red Hat doing - that's up to Red Hat's business managers
> 
> - is it worth merging into the kernel - that's not
> 
> The capability bit is small and clean the rest of it is beginning to look
> far too ugly for upstream right now. Not to say it might not end up small
> and clean in the end.

I absolutely agree - the code has to be good enough to be accepted 
upstream and I've no objection to being told that better implementations 
must be produced. I do object to being told that there's no point in 
trying to find an acceptable implementation.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
