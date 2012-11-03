Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab2KCQhv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 12:37:51 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:51510 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454Ab2KCQhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 12:37:46 -0400
MIME-Version: 1.0
In-Reply-To: <20121103163152.1405e2cb@pyramind.ukuu.org.uk>
References: <20121101212843.GA20309@srcf.ucam.org>
	<20121101213751.377ebaa8@pyramind.ukuu.org.uk>
	<20121101213452.GA20564@srcf.ucam.org>
	<20121101215817.79e50ec2@pyramind.ukuu.org.uk>
	<20121101215752.GA21154@srcf.ucam.org>
	<87625ogzje.fsf@xmission.com>
	<20121102140057.GA4668@srcf.ucam.org>
	<87liejacix.fsf@xmission.com>
	<20121103002033.GA18691@srcf.ucam.org>
	<87sj8rwm0p.fsf@xmission.com>
	<20121103014332.GA20065@srcf.ucam.org>
	<20121103163152.1405e2cb@pyramind.ukuu.org.uk>
Date: Sat, 3 Nov 2012 12:37:44 -0400
Message-ID: <CACLa4pt3_Fc5fHKf=ihzV0zDb7zvCyzWp92YLakjGqL7MCaiEA@mail.gmail.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
From: Eric Paris <eparis@parisplace.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Chris Friesen <chris.friesen@genband.com>,
        Josh Boyer <jwboyer@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        linux-efi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 3, 2012 at 12:31 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> You're guaranteed to be able
>> to do this on any Windows 8 certified hardware.
>
> Thats not my understanding of the situation.

Windows 8 certification has this as a requirement for x86 hardware.  I
belied the opposite is a requirement for arm hardware.  However it's
possible that it just doesn't specifiy at all for arm.

So yes, you're guaranteed to be able to do this on any Windows 8
certified x86 hardware.
