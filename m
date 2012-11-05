Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262Ab2KETQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 14:16:24 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:51259 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab2KETQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 14:16:23 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
References: <20121103002244.GC18691@srcf.ucam.org>
	<1351944236.2417.7.camel@dabdike.int.hansenpartnership.com>
	<20121103134630.GA28166@srcf.ucam.org>
	<1351983400.2417.21.camel@dabdike.int.hansenpartnership.com>
	<20121104042802.GA11295@srcf.ucam.org>
	<1352020487.2427.5.camel@dabdike.int.hansenpartnership.com>
	<20121104135251.GA17894@srcf.ucam.org> <87d2zsmv8r.fsf@xmission.com>
	<509766DB.9090906@zytor.com> <87625kh5r2.fsf@xmission.com>
	<20121105123858.GB4374@srcf.ucam.org>
Date: Mon, 05 Nov 2012 11:16:12 -0800
In-Reply-To: <20121105123858.GB4374@srcf.ucam.org> (Matthew Garrett's message
	of "Mon, 5 Nov 2012 12:38:58 +0000")
Message-ID: <87sj8nc137.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/uyY5b2aIqCOApJe+vBAGT0hleH2DWVuk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Matthew Garrett <mjg59@srcf.ucam.org>
X-Spam-Relay-Country: 
Subject: Re: [RFC] Second attempt at kernel secure boot support
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> On Sun, Nov 04, 2012 at 11:24:17PM -0800, Eric W. Biederman wrote:
>> "H. Peter Anvin" <hpa@zytor.com> writes:
>> >
>> > That is a hugely different thing from needing a console.
>> 
>> Not at all.
>> 
>> In the general case user intereaction is required to tell the system to
>> boot off of your choosen boot media instead of the local hard drive.
>
> No, in the general case the system will do that once it fails to find a 
> bootable OS on the drive.

In the general case there will be a bootable OS on the drive.

Eric

