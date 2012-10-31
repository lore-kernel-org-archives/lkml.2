Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935324Ab2JaJ4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:56:37 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:46824 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab2JaJ4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:56:33 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/ll2s7qFK2M
X-RZG-CLASS-ID: mo00
Date: Wed, 31 Oct 2012 10:56:31 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Pasi =?utf-8?B?S8Okcmtrw6RpbmVu?= <pasik@iki.fi>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] [PATCH] xen PVonHVM: require at least Xen 3.4 as dom0
Message-ID: <20121031095631.GA27937@aepfle.de>
References: <1351613105-24408-1-git-send-email-olaf@aepfle.de>
 <20121030181732.GZ8912@reaktio.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121030181732.GZ8912@reaktio.net>
User-Agent: Mutt/1.5.21.rev5555 (2012-07-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, Pasi Kärkkäinen wrote:

> On Tue, Oct 30, 2012 at 05:05:05PM +0100, Olaf Hering wrote:
> > The XenPVHVM extensions have not been tested much on very old
> > hypervisors. At least Xen 3.4 gets some testing with the pvops kernel.

> IIRC upstream Linux PVonHVM drivers do work OK today on RHEL5 Xen, 
> which advertises itself as Xen 3.1.2-based..

Konrad,

based on this info, please drop this patch.
It does not fix a real bug.

Olaf
