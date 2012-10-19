Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab2JSTL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 15:11:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60008 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab2JSTL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 15:11:28 -0400
Date: Fri, 19 Oct 2012 21:11:15 +0200
From: Heinz Diehl <htd@fritha.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heinz Diehl <htd@fancy-poultry.org>, Ben Skeggs <bskeggs@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 60/76] drm/nouveau/bios: fix shadowing of ACPI ROMs larger
 than 64KiB
Message-ID: <20121019191115.GA1635@fritha.org>
References: <20121019024350.087156547@linuxfoundation.org>
 <20121019024359.774396402@linuxfoundation.org>
 <20121019160103.GA1570@fritha.org>
 <20121019174807.GA3017@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019174807.GA3017@kroah.com>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+66 (70810a88ce9f) (2011-07-01)
X-Provags-ID: V02:K0:7o1T8x948VKHY4XhOOvdsMccDuriGk2XQXzhl6zuB35
 OucMR+2N8/pTrbGc/bjFQcDMSgMdSalmrYpnRjq7zzRC9QgDzb
 /G1ohD7dql+1bjBVwCl+8dvEX3jgSJ99KwaT5ZMB3MEEMTutGK
 BQhwrOZ3JNPfvxOSIrqFfw6LGbZ474ebNMR07CupwzlW5ypDd4
 yepIKZpyFVvVrrCPoy0yhJAWPDyRGFGr5Rubhoy28Ui5aRuBW6
 Jhm6iOlU9CudNb7USQOKmB0orIgvmpYFkTafEL+ZrWeAmXZDq2
 fJIWaHQF+CGxloPfn444gNakV4RQmxEhGn0e6XWnk8lnd3IBok
 hFCYmQrs23E3AxQjEHPk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.10.2012, Greg Kroah-Hartman wrote: 

> Does Linus's 3.7 git tree also crash for you this way?

Yes, it crashes in the same way with latest linus git 3.7.
Here's the screenshot:

http://www.fritha.org/crash-linus-git.jpg

