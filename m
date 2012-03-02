Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728Ab2CBWJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 17:09:12 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56681 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089Ab2CBWJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 17:09:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH v2 0/6] ARM: Tegra: cleanup patches from Arnd Bergmann
Date: Fri, 2 Mar 2012 22:09:04 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Alan Ott <alan@signal11.us>, Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <1330721884-8495-1-git-send-email-alan@signal11.us> <4F513DE3.9020707@signal11.us> <74CDBE0F657A3D45AFBB94109FB122FF17BE861A73@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BE861A73@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203022209.04419.arnd@arndb.de>
X-Provags-ID: V02:K0:rfsGbcBT+cLroMgTWaRo4/Ml3DsG3qkvV0ELok0E+jW
 NHt95i3XjkpTXTsdomNhoWxW/7YFdRWxtxh+mXADEbOPLKvsk1
 RDjezx0Yq9hgPBzvEbTZlTALWghtLnxGEXmLXAIatuAOb63cCS
 47gFwCTIwTCcY0Sp7gXEb4avNhu1hCuyixqZUt5ycgk0IUe8BG
 NyK5kaya89GEw/6Y5CvTa9QNh1SSrMyDR23nQx56EvOkXTil4t
 kC4WND3O2mD54PDb2EMmAT45tAMptD3UoK13qHYI77yiflfBRv
 ijrYwgNBlWeos6P3NRTZE4azOaCDLZaeprJlHeDyFrDzWjdgU1
 xCwDTqJyluVtwSE1dQVY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 March 2012, Stephen Warren wrote:
> > For patch #5 (ARM: tegra: USB_ULPI needs USB), it didn't look to me like
> > there was a resolution on that thread yesterday. On reading it again, if
> > we change
> >     select USB_ULPI if USB_SUPPORT
> > to:
> >     select USB_ULPI if USB
> > for both Tegra 2 and 3, does that satisfy you and Arnd?
> 
> I believe so yes. Thanks.

Agreed.

	Arnd
