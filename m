Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab1HXQoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 12:44:06 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62322 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab1HXQoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 12:44:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAJL_dMug+L0oQjeDs_3Xs2s2=-_3ci-Ab5-iDS8Up5u-xbaHiw@mail.gmail.com>
References: <CAFWT=833UrQ0irJfL5z=6R97+wd4ewW9Cd88maeXhZ_95aMhsw@mail.gmail.com>
	<20110824001137.GA23979@somewhere>
	<CAFWT=83FNbAHUtPiouD3R06LEze5w1Mv07EL-x9VxSs_EXuruA@mail.gmail.com>
	<20110824135852.GE23979@somewhere>
	<4E5513FA.6060904@linux.intel.com>
	<CAJL_dMug+L0oQjeDs_3Xs2s2=-_3ci-Ab5-iDS8Up5u-xbaHiw@mail.gmail.com>
Date: Wed, 24 Aug 2011 12:44:02 -0400
Message-ID: <CAFWT=80YV-+-COSfGnuDTSxqy17kgXCQpCVJD1b2yif_nM=1Yg@mail.gmail.com>
Subject: Re: Bug Report for Linux Kernel 3.x
From: Steevven1 <steevven1@gmail.com>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 11:52 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> Hi all,
>
>
> Make sure you read this:
>
> Tweaks To Extend The Battery Life Of Intel Linux Notebooks
> http://www.phoronix.com/scan.php?page=article&item=intel_i915_power&num=1
>
> Linux 3.1 Kernel Draws More Power With Another Regression
> http://www.phoronix.com/scan.php?page=article&item=linux_31_power_regress&num=1
>

VERY interesting! The second link seems to imply that Phoronix has
independently found this same bug that we've been talking about in my
originally-linked ubuntuforums discussion. Specifically, the
interesting quote is:

"Besides the new Linux 3.1 kernel power regression, there's also a
power regression introduced in the Linux 3.0 kernel that has
previously not been talked about on Phoronix. The Linux 3.0 power draw
is up by 24% over the Linux 2.6.39 kernel."
