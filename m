Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2KEU0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:26:31 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43350 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab2KEU03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:26:29 -0500
Date: Mon, 5 Nov 2012 20:25:57 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121105202557.GA16076@srcf.ucam.org>
References: <20121103134630.GA28166@srcf.ucam.org>
 <1351983400.2417.21.camel@dabdike.int.hansenpartnership.com>
 <20121104042802.GA11295@srcf.ucam.org>
 <1352020487.2427.5.camel@dabdike.int.hansenpartnership.com>
 <20121104135251.GA17894@srcf.ucam.org>
 <87d2zsmv8r.fsf@xmission.com>
 <509766DB.9090906@zytor.com>
 <87625kh5r2.fsf@xmission.com>
 <20121105123858.GB4374@srcf.ucam.org>
 <87sj8nc137.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sj8nc137.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 11:16:12AM -0800, Eric W. Biederman wrote:
> Matthew Garrett <mjg59@srcf.ucam.org> writes:
> > No, in the general case the system will do that once it fails to find a 
> > bootable OS on the drive.
> 
> In the general case there will be a bootable OS on the drive.

That's in no way a given.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
