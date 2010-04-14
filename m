Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab0DNOF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:05:26 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:59122 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab0DNOFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:05:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=md0Ym4M5Kdneqwa+JJuKIt85fmBqOveqQT7LD8AQU5dIoBr4tkGEArPBWlpHPfeT2K
         0+2kqToOu9mvLeg6aZgshwAK1Zlx58An44jidfjQ6vJQ9zAgZmj6ApAhHwbVrcf2bZW1
         cWIm53II2ElYsXHW2oxjeZusHrzyCw053nmDg=
Date: Wed, 14 Apr 2010 17:05:17 +0300 (EEST)
From: Tero Roponen <tero.roponen@gmail.com>
X-X-Sender: terrop@terrop
To: Alexey Starikovskiy <astarikovskiy@suse.de>
cc: Tero Roponen <tero.roponen@gmail.com>,
       Luca Tettamanti <kronos.it@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, len.brown@intel.com
Subject: Re: [acpi:battery?] kernel oops on boot
In-Reply-To: <4BC5CA13.3070801@suse.de>
Message-ID: <alpine.LFD.2.00.1004141704350.1535@terrop>
References: <20100414095750.GA3304@swordfish.minsk.epam.com> <20100414131324.GA6598@nb-core2.darkstar.lan> <alpine.LFD.2.00.1004141641010.3640@terrop> <4BC5CA13.3070801@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-73982546-1271253922=:1535"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-73982546-1271253922=:1535
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Wed, 14 Apr 2010, Alexey Starikovskiy wrote:

> 14.04.2010 17:50, Tero Roponen пишет:
> > 
> > On Wed, 14 Apr 2010, Luca Tettamanti wrote:
> > 
> > > Hello,
> > > I'm seeing a similar bug on my notebook (Asus F3Sa) with current git.
> > > -rc4 does not work, while -rc3 does work.
> > > 
> > > The error (at least in my case) is a division by zero in
> > > acpi_ex_insert_into_field.
> > 
> > I have a similar problem with Asus M50Vm. git-bisect found
> > the following commit and reverting it does indeed fix the
> > problem.
> > 
> > commit dadf28a10c3eb29421837a2e413ab869ebd9e168
> > Author: Alexey Starikovskiy<astarikovskiy@suse.de>
> > Date:   Wed Mar 17 13:14:13 2010 -0400
> > 
> >      ACPI: EC: Allow multibyte access to EC
> > 
> >      http://bugzilla.kernel.org/show_bug.cgi?id=14667
> > 
> >      Signed-off-by: Alexey Starikovskiy<astarikovskiy@suse.de>
> >      Signed-off-by: Len Brown<len.brown@intel.com>
> > 
> Please see the patch in https://bugzilla.kernel.org/show_bug.cgi?id=15749

Work for me. Thanks.

Tested-by: Tero Roponen <tero.roponen@gmail.com>
--8323328-73982546-1271253922=:1535--
