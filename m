Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935364Ab1JEVny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 17:43:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65412 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab1JEVnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 17:43:53 -0400
MIME-Version: 1.0
In-Reply-To: <4E8982E3.9080809@linux.vnet.ibm.com>
References: <CAG1a4rvdYnOSWu3DJ+DL+Q_bfsfTv_px20vP06fBKRm6B8cwMw@mail.gmail.com>
 <4E8982E3.9080809@linux.vnet.ibm.com>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Wed, 5 Oct 2011 17:43:22 -0400
Message-ID: <CAG1a4rvYX9P+vHTLQBV_edViU8QriT=mrut0c5oS5YZ96L3x=A@mail.gmail.com>
Subject: Re: Full lockup when compiling kernel with "optimal" number of threads
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 5:39 AM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 09/03/2011 09:04 AM, Pavel Ivanov wrote:
>> Hi,
>>
>> I can reliably reproduce a complete machine lockup when compiling
>> kernel sources with "make -j". After making some progress machine
>> stops responding to anything (including CapsLock/NumLock switching or
>> mouse moving) and after hard reboot nothing is left in kern.log or
>> syslog. Only attaching a serial console gives me the following clues
>> to what happens:
>>
> By the way "optimal" is supposed to be make -j <nr_cpus*2> isn't it?
> IIRC, "maximal" refers to make -j

I'm sure I didn't make up that word "optimal" by myself. I took it
from some documentation or internet, although now I can't find where I
took it from. Wherever I look it says that -j is "unbounded" number of
threads.

Pavel
