Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab1FUBqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 21:46:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40915 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab1FUBqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 21:46:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=E3f4DisDG6wxzyTZSNMbbdY+AIU+AofxxDF9pYpkPjhYMzTuqYIj4DjuSShr1wuaue
         CZp3DGO8rl0o92se5C2wpTmq6FeKIy1b61xFXiFxpfqlu2sWR0r7ZeBtmRXJgJhMaQEw
         FKCW3/+mWlNUjR/m+cCRGdc5NxiThDRIVLOwU=
MIME-Version: 1.0
In-Reply-To: <20110621003507.GG1905@opensource.wolfsonmicro.com>
References: <20110617103218.GA29723@opensource.wolfsonmicro.com>
 <1308310831-27861-1-git-send-email-lars@metafoo.de> <4DFB53B3.8070806@ladisch.de>
 <BANLkTimWfT_LSLX36oLcSSYNqi4buBiJUQ@mail.gmail.com> <4DFB98EE.9000609@ladisch.de>
 <BANLkTi=idGOgMkBXF6p-Uo9ARAmgb1uR_g@mail.gmail.com> <20110621003507.GG1905@opensource.wolfsonmicro.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 20 Jun 2011 21:45:56 -0400
X-Google-Sender-Auth: Ncg99RJ-MdiQ5mJqW4g-cN7rGXo
Message-ID: <BANLkTinGMN8A99YZMVa1XDRuy3rUSO2UGg@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH] firmware: Make firmware drivers
 generally available
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-ia64@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 20:35, Mark Brown wrote:
> On Fri, Jun 17, 2011 at 02:25:21PM -0400, Mike Frysinger wrote:
>> On Fri, Jun 17, 2011 at 14:11, Clemens Ladisch wrote:
>> > "drivers/firmware" is the obvious name for both, but that makes
>> > it ambiguous.  I'd suggest to split the two subsystems into
>> > "drivers/host-firmware" and "drivers/device-firmware".
>
>> i honestly dont see how this is better.  the drivers/firmware/ isnt
>> exactly overflowing, and differentiating between the two modes doesnt
>> seem to gain us anything.
>
> Do we have anything like an actual subsystem in firmware?  If we do and
> it's sensible to do things that affect all firmwares then splitting
> seems reasonable but if not then it's less clear.

i dont think there is.  we havent hit enough critical mass yet to warrant it.
-mike
