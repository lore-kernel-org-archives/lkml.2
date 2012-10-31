Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935790Ab2JaQKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:10:34 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56177 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935724Ab2JaQKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:10:32 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1210311703560.12781@pobox.suse.cz>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	<20121029174131.GC7580@srcf.ucam.org>
	<alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
	<CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
	<alpine.LNX.2.00.1210311703560.12781@pobox.suse.cz>
Date: Wed, 31 Oct 2012 12:10:31 -0400
Message-ID: <CA+5PVA7KK1aKAOroSSJ2Zo14AeAD2P-_oiKK1Yct0e--40bsPw@mail.gmail.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
From: Josh Boyer <jwboyer@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 12:04 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 31 Oct 2012, Josh Boyer wrote:
>
>> I have a patch that disables that.  I imagine it will be included in the
>> next submission of the patchset.
>>
>> You can find it here in the meantime:
>>
>> http://jwboyer.fedorapeople.org/pub/0001-hibernate-Disable-in-a-Secure-Boot-environment.patch
>
> I don't see that patch touching kernel/power/user.c, so using 's2disk' to
> suspend machine seems to be still possible even with this patch applied,
> right?

Oh, yes.  Good catch.  I'll add similar checks there as well in the next
revision.  Thanks!

josh
