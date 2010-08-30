Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab0H3RJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:09:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64279 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab0H3RJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:09:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: hv block drivers
Date: Mon, 30 Aug 2010 19:08:51 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Hank Janssen <hjanssen@microsoft.com>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>
References: <201008301643.42253.arnd@arndb.de> <4C7BD9A6.1090108@goop.org>
In-Reply-To: <4C7BD9A6.1090108@goop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008301908.51521.arnd@arndb.de>
X-Provags-ID: V02:K0:JlTnlK3pyNjepzqD/3dKhiAurUSaYSVMr60iY+IHLb0
 oHdrTGEV/tVXrat2mbDqdFXf3WNOykxnRTRAG1pnHqV816HqcM
 savR4rga8J9gjwatfKBQJyF7+OYXEZBUz8W+SHchpqIP280H1Q
 3fSLrkZ0bXotMVh1dTKh6rim9qyykIZ/GMDYqXOkA2z0kZwpNe
 mqMwtfWX0xmjQe8VNl+1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 August 2010, Jeremy Fitzhardinge wrote:
> Have you investigated making virtio a scsi device?

I doubt that there is much value in changing it now, and it's not something
I'd be interested in working on.

For the HyperV drivers, it probably makes sense because half of it is
trying to look like SCSI anyway, while the other half is trying to look
like ATA. For the ATA driver, the obvious choice would be to make it
a libata backend, though my impression from a brief look at the driver
was that it's better to copy some of the libata code and integrate it
into the hv SCSI driver.

	Arnd
