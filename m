Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab2KFPPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 10:15:10 -0500
Received: from exprod7og127.obsmtp.com ([64.18.2.210]:45951 "EHLO
	exprod7og127.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab2KFPPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 10:15:07 -0500
Message-ID: <50992946.4060101@genband.com>
Date: Tue, 06 Nov 2012 09:14:14 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Florian Weimer <fw@deneb.enyo.de>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Eric Paris <eparis@parisplace.org>,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
References: <20121104135251.GA17894@srcf.ucam.org>	<87d2zsmv8r.fsf@xmission.com> <509766DB.9090906@zytor.com>	<87625kh5r2.fsf@xmission.com> <20121105123858.GB4374@srcf.ucam.org>	<87sj8nc137.fsf@xmission.com> <20121105202557.GA16076@srcf.ucam.org>	<87hap3zbw7.fsf@xmission.com> <20121106031219.GB24235@srcf.ucam.org>	<87fw4nv1vj.fsf@xmission.com> <20121106035352.GA24698@srcf.ucam.org>	<87hap3s3yl.fsf@xmission.com> <878vafqi5q.fsf@mid.deneb.enyo.de>
In-Reply-To: <878vafqi5q.fsf@mid.deneb.enyo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Nov 2012 15:14:14.0859 (UTC) FILETIME=[621539B0:01CDBC31]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19344.004
X-TM-AS-Result: No--9.079600-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 01:56 AM, Florian Weimer wrote:

> Personally, I think the only way out of this mess is to teach users
> how to disable Secure Boot.

If you're going to go that far, why not just get them to install a 
RedHat (or SuSE, or Ubuntu, or whoever) key and use that instead?

Secure boot does arguably solve a class of problems, so it seems a bit 
odd to recommend just throwing it out entirely.

Chris
