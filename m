Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab2KEHk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 02:40:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60106 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269Ab2KEHk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 02:40:58 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <87625kh5r2.fsf@xmission.com>
References: <20121102175416.GA11816@srcf.ucam.org> <1351879058.2439.46.camel@dabdike.int.hansenpartnership.com> <20121102180458.GA12052@srcf.ucam.org> <1351899503.2439.49.camel@dabdike.int.hansenpartnership.com> <20121103002244.GC18691@srcf.ucam.org> <1351944236.2417.7.camel@dabdike.int.hansenpartnership.com> <20121103134630.GA28166@srcf.ucam.org> <1351983400.2417.21.camel@dabdike.int.hansenpartnership.com> <20121104042802.GA11295@srcf.ucam.org> <1352020487.2427.5.camel@dabdike.int.hansenpartnership.com> <20121104135251.GA17894@srcf.ucam.org> <87d2zsmv8r.fsf@xmission.com> <509766DB.9090906@zytor.com> <87625kh5r2.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC] Second attempt at kernel secure boot support
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 05 Nov 2012 08:40:21 +0100
To: ebiederm@xmission.com
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Message-ID: <8582ea67-beda-44e6-82cd-52d73555dda8@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not a good thing to assume.  A vendor could have an external button, gor example.

ebiederm@xmission.com wrote:

>"H. Peter Anvin" <hpa@zytor.com> writes:
>
>> On 11/05/2012 07:14 AM, Eric W. Biederman wrote:
>>> 
>>> In any case the notion that unattended install with no user
>interaction
>>> on any uefi machine in any state is complete and total rubbish.  It
>>> can't be done.  You need power and you need boot media.
>>> 
>>
>> That is a hugely different thing from needing a console.
>
>Not at all.
>
>In the general case user intereaction is required to tell the system to
>boot off of your choosen boot media instead of the local hard drive.
>
>Eric

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
