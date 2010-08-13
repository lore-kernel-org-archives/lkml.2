Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab0HMXgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 19:36:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60277 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab0HMXgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 19:36:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Khhm5hkMl5BeLTlDkAlL3IeInWciBHQARXhgKMUPJA1fVqaWk1gxkulOgW7yPNLFlU
         8/kiioqdv+xowCXTZ999ex+T97/zxULx4wo7Zrsn3mxtFwVdYnBidGQlxwb81DuY2Z4q
         ZnOUIPlCjzrt1AmgDdWonOxax0SuTub0EycS4=
MIME-Version: 1.0
In-Reply-To: <4C65D263.6050904@zytor.com>
References: <F0CB3B1C601247indou.takao@jp.fujitsu.com>
	<4C65C630.4070008@zytor.com>
	<987664A83D2D224EAE907B061CE93D53015B2DAD87@orsmsx505.amr.corp.intel.com>
	<m1r5i2kt0n.fsf@fess.ebiederm.org>
	<4C65D263.6050904@zytor.com>
Date: Fri, 13 Aug 2010 16:36:03 -0700
Message-ID: <AANLkTim8U87uZ73BcFc42O6EFWuNkA5UjhhiNeVLtAWT@mail.gmail.com>
Subject: Re: [PATCH][EFI] Run EFI in physical mode
From: Tony Luck <tony.luck@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 4:16 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> I guess my real question was "is this something IA64 could benefit from
> and/or could we make the IA64 code more similar to the x86 bits"?

If Eric's recollection about the "weird floating point fixup routines"[1]
performance issues are correct - then ia64 won't want to do this.

-Tony

[1] more usually called FPSWA - floating point software assist - which
handle a bunch or corner cases in denormalized floating point values
that the h/w doesn't cover.
