Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab1LTXiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:38:05 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:44809
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753404Ab1LTXiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:38:02 -0500
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI9371I98dKzz1202hzz8275ch8275bh8275dhz2fh668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4EF11C48.4060809@am.sony.com>
Date: Tue, 20 Dec 2011 15:37:44 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Geunsik Lim <leemgs1@gmail.com>
CC: linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Android mainlining project
References: <4EEFD926.3040201@am.sony.com>  <CABiHV1Q2SyXX3h99tAo6Z4tmd1HUsj0KaQB5OV3qqm4Yn8P2ag@mail.gmail.com>
In-Reply-To: <CABiHV1Q2SyXX3h99tAo6Z4tmd1HUsj0KaQB5OV3qqm4Yn8P2ag@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 03:27 PM, Geunsik Lim wrote:
> On Tue, Dec 20, 2011 at 9:39 AM, Tim Bird <tim.bird@am.sony.com> wrote:
>> The wiki page for this effort (still under construction) is
>> at: http://elinux.org/Android_Mainlining_Project
> Actually, current linux-next tree is not including ashmem(anonymous
> shared memory).
> When I checked android kernel features of linux-next(20111219),
> Wakelock API feature(./kernel/power/*lock.c) still isn't appeared in
> linux-next tree.

Both of these (wakelocks and ashmem) are listed as "not mainlined"
in the table on the wiki page.  Ashmem is apparently being
worked on (see the lwn.net article).
 -- Tim


=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

