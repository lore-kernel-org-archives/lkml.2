Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab1C1RZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:25:45 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49795 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab1C1RZn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:25:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fHIf9mxMnbfvszlzxiyVyupnkJlkLqg/I0y5R7JqQbgJvT+6W39cAzrfI3o+v1Gqi0
         OAnK+bEi9Ssf7tCtWn78bFehFzZv2M+MVirm1gOOtNCX5sEtt9J5jBHpzCpPoREP/Tnf
         pxd/HG5szxvWtdDNkIPAHyyxdGbQR4o0fH9o4=
MIME-Version: 1.0
In-Reply-To: <20110328160241.GA20992@srcf.ucam.org>
References: <Pine.LNX.4.64.1103242007300.2677@boston.corp.fedex.com>
	<20110324122409.GA1564@srcf.ucam.org>
	<AANLkTinKrG-N8O4_qf4SWuZ+W6VvFhyyLEw2ht0PFKSo@mail.gmail.com>
	<BANLkTimPvW0Y5yqaW7WngOghhZGafVZS6w@mail.gmail.com>
	<20110328125319.GA28847@srcf.ucam.org>
	<AANLkTik0Zt=ecj-p6GBSWwQMopE7GvmFV7b7jRv=y7yJ@mail.gmail.com>
	<20110328160241.GA20992@srcf.ucam.org>
Date: Mon, 28 Mar 2011 19:25:42 +0200
Message-ID: <BANLkTinTbez8+AMF9KaAx+Y5NFW_RMP5ig@mail.gmail.com>
Subject: Re: Commit 9661e92c10a9775243c1ecb73373528ed8725a10: sysfs: cannot
 create duplicate filename '/devices/pci0000:00/0000:00:02.0/backlight/acpi_video0/device'
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 6:02 PM, Matthew Garrett <mjg@redhat.com> wrote:
> On Mon, Mar 28, 2011 at 08:22:05AM -0700, Linus Torvalds wrote:
>> On Mon, Mar 28, 2011 at 5:53 AM, Matthew Garrett <mjg@redhat.com> wrote:
>> >
>> > I just sent a patch to fix this.
>>
>> Grr. Any more details, please? Who to? What's the fix? Actual patch
>> for reporters to validate?
>
> Sorry, yes - https://patchwork.kernel.org/patch/668351/

Works on top of my -git18 + (unrelated) LVDS detection patch, thanks.

Tested-by: Alessandro Suardi <alessandro.suardi@gmail.com>

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
