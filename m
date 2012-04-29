Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab2D2DKZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 23:10:25 -0400
Received: from relay.ihostexchange.net ([66.46.182.51]:52235 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab2D2DKX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 23:10:23 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Apr 2012 23:10:23 EDT
From: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@ScaleMP.com>
To: Ido Yariv <ido@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 28 Apr 2012 23:05:08 -0400
Subject: RE: [PATCH v2 1/2] vsmp: Fix number of CPUs when vsmp is disabled
Thread-Topic: [PATCH v2 1/2] vsmp: Fix number of CPUs when vsmp is disabled
Thread-Index: Ac0lhos74p7Bpmk4REOBnbb21YU2TwALka8g
Message-ID: <9B14D1490DDECA4E974F6B9FC9EBAB317D0A413E09@VMBX108.ihostexchange.net>
References: <1333715987-26059-2-git-send-email-ido@wizery.com>
	<1334561976-13965-1-git-send-email-ido@wizery.com>
 <CANtih+8zidrJoC4t7YgWW4wU5dj_-WE5xDSprGFVFtpqE4PR5w@mail.gmail.com>
In-Reply-To: <CANtih+8zidrJoC4t7YgWW4wU5dj_-WE5xDSprGFVFtpqE4PR5w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm all in favor of this - can we get this in, please ?


--Shai 


-----Original Message-----
From: Ido Yariv [mailto:ido@wizery.com] 
Sent: Sunday, April 29, 2012 00:33
To: linux-kernel@vger.kernel.org; Thomas Gleixner; Ingo Molnar; H. Peter Anvin
Cc: Shai Fultheim (Shai@ScaleMP.com); Ido Yariv
Subject: Re: [PATCH v2 1/2] vsmp: Fix number of CPUs when vsmp is disabled

Hi,

On Mon, Apr 16, 2012 at 10:39 AM, Ido Yariv <ido@wizery.com> wrote:
> From: Shai Fultheim <shai@scalemp.com>
>
> In case CONFIG_X86_VSMP is not set, limit the number of CPUs to the
> number of CPUs of the first board.
>
> Signed-off-by: Shai Fultheim <shai@scalemp.com>
> [ido@wizery.com: rebased, fixed minor coding-style issues]
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---
>  arch/x86/kernel/vsmp_64.c |   48 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 48 insertions(+), 0 deletions(-)

Any thoughts on this set?

Thanks,
Ido.
