Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab2JaRBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:01:45 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:42637 "EHLO
	homiemail-a47.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750992Ab2JaRBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:01:43 -0400
Message-ID: <50915975.8030503@shealevy.com>
Date: Wed, 31 Oct 2012 13:01:41 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20121020 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jiri Kosina <jkosina@suse.cz>, Josh Boyer <jwboyer@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz> <20121029174131.GC7580@srcf.ucam.org> <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz> <CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com> <20121031155503.1aaf4c93@pyramind.ukuu.org.uk> <alpine.LNX.2.00.1210311653080.12781@pobox.suse.cz> <20121031170334.59833fb1@pyramind.ukuu.org.uk>
In-Reply-To: <20121031170334.59833fb1@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 01:03 PM, Alan Cox wrote:
> On Wed, 31 Oct 2012 16:55:04 +0100 (CET)
> Jiri Kosina <jkosina@suse.cz> wrote:
>
>> On Wed, 31 Oct 2012, Alan Cox wrote:
>>
>>> All this depends on your threat model. If I have physical access to
>>> suspend/resume your machine then you already lost. If I don't have
>>> physical access then I can't boot my unsigned OS to patch your S4 image
>>> so it doesn't matter.
>> Prepare (as a root) a hand-crafted image, reboot, let the kernel resume
>> from that artificial image.
> It's not signed. It won't reboot from that image.

So then to hibernate the kernel must have a signing key?

> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

