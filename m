Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab0H3TT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 15:19:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65343 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab0H3TT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 15:19:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: hv block drivers
Date: Mon, 30 Aug 2010 21:18:59 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35+; KDE/4.5.0; x86_64; ; )
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Hank Janssen <hjanssen@microsoft.com>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
References: <201008301643.42253.arnd@arndb.de> <8AFC7968D54FB448A30D8F38F259C56224274727@TK5EX14MBXC118.redmond.corp.microsoft.com> <4C7BEBE7.8060502@goop.org>
In-Reply-To: <4C7BEBE7.8060502@goop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008302119.00069.arnd@arndb.de>
X-Provags-ID: V02:K0:1UmPnaqnAWBpDUtYlPYQSB7yAtJswXmCt2BiIUxycXE
 q962tvUVXKyRODQmERfisOmcwSlDh7sWzHB/pIB0kHDRpYieVX
 0T+JF1h61ARKxRfanHaeIGXcy8B9kj+ogv2sZWNa+7j1T/Xwmp
 Nefvx91opqlGfGzT5ssjNqR8rCAIX7tOe9xzmUAytLmjcSlTXR
 yYs+IgqRXs3zCzPa6fS1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 August 2010 19:35:35 Jeremy Fitzhardinge wrote:
>  On 08/30/2010 10:31 AM, Hank Janssen wrote:
> > For a more general question, When/if we make it out of staging, where should these drivers live?
> >
> >       drivers/hyper-v or drivers/scsi and drivers/ide.
> >
> > Is there a standard that is being followed?
> 
> If they're not actually scsi/ide subsystem drivers, then drivers/block
> would seem like the best place (and drivers/ide is truly ancient stuff,
> I think).

Agreed, although I was suggesting to make them SCSI drivers, so they
would go to drivers/scsi/ or a subdirectory of it in that case.

	Arnd
