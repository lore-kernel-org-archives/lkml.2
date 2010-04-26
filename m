Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab0DZPf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 11:35:29 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:52343 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753235Ab0DZPf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 11:35:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=g1vbwGPVG5FxamXjnAvBtzzIR6ZMzO1TDZZ6Z1vntKWf0YeibrtXWOTaLx37rWqz1VvqOopNO8DZZxiJbwQYHWqF7xN0ypU2RWk6/JD7E/+/sxE0zpDtm1Q0ChywQ1Dg;
Date: Mon, 26 Apr 2010 08:35:22 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai <yinghai.lu@oracle.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andy Isaacson <adi@hexapodia.org>, guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH -v3 1/3] x86: Reserve [0xa0000, 0x100000] in e820 map
Message-ID: <20100426083522.5bf4f926@virtuousgeek.org>
In-Reply-To: <4BD22D99.5000603@zytor.com>
References: <20100409223532.GC11130@hexapodia.org>
	<4BBFB1D8.6090802@oracle.com>
	<20100410000030.GE11130@hexapodia.org>
	<4BBFD019.9040405@oracle.com>
	<20100410014308.GG11130@hexapodia.org>
	<4BBFD8EF.6020108@oracle.com>
	<20100410015711.GH11130@hexapodia.org>
	<4BBFE66C.2040603@oracle.com>
	<20100412185416.GA19959@hexapodia.org>
	<4BC375D9.4040503@oracle.com>
	<20100412200224.GO11130@hexapodia.org>
	<4BC39F67.4090407@oracle.com>
	<1271192527.6035.44.camel@dc7800.home>
	<4BC4DD85.5030203@zytor.com>
	<4BC4DDEA.60202@oracle.com>
	<4BC4DFAD.9020600@zytor.com>
	<4BC4E09F.9000608@oracle.com>
	<4BD22D99.5000603@zytor.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 16:30:33 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Hi Jesse,
> 
> I am considering putting this patch plus the two followup patches in my
> next set of fixes to Linus.  However, the two followup patches are
> really more PCI-related than x86-related, so I would appreciate your OK.
> 
> I'm using this version (-v3) because the latter cleanup (removing
> probe_rom_32.c for example) do not seem to be .34 material.
> 
> For the followup patches:
> 
> http://marc.info/?i=4BC4E0E9.7000203@oracle.com
> http://marc.info/?i=4BC4E115.90805@oracle.com

I was going to congratulate Yinghai on writing good changelogs, but
then I saw Bjorn actually wrote these ones for him. :)  At any rate they
looks good:

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>



-- 
Jesse Barnes, Intel Open Source Technology Center
