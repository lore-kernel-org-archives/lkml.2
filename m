Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab0LAU5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 15:57:19 -0500
Received: from mxs.selfmail.ru ([77.221.143.26]:47860 "EHLO mxs.selfmail.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755788Ab0LAU5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 15:57:18 -0500
X-Greylist: delayed 782 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Dec 2010 15:57:18 EST
X-ACL-SPF: 
Subject: Re: [Xen-devel] [PATCH 0/2] Xen PV on HVM multiple PV consoles
From: Vasiliy G Tolstov <v.tolstov@selfip.ru>
Reply-To: v.tolstov@selfip.ru
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
In-Reply-To: <alpine.DEB.2.00.1012011715070.14723@kaball-desktop>
References: <alpine.DEB.2.00.1012011715070.14723@kaball-desktop>
Content-Type: text/plain; charset="UTF-8"
Organization: Selfip.Ru
Date: Wed, 01 Dec 2010 23:43:53 +0300
Message-ID: <1291236234.22027.0.camel@mobile>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-ACL-DATA: Invalid Message-Id
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 18:25 +0000, Stefano Stabellini wrote:
> Hi all,
> this small patch series achieves two goals:
> 
> - make PV consoles work for PV on HVM guests;
> 
> - implement support for multiple PV consoles for PV and PV on HVM guests.
> 
> Stefano Stabellini (2):
>       hvc_xen: support PV on HVM consoles
>       hvc_xen: implement multiconsole support
> 
>  drivers/char/hvc_xen.c             |  479 ++++++++++++++++++++++++++++++++----
>  include/xen/interface/hvm/params.h |    6 +-
>  2 files changed, 441 insertions(+), 44 deletions(-)
> 
> A branch with these patches on 2.6.37-rc4 is available here:
> 
> git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.37-rc4-pvhvm-pvconsole
> 
> Cheers,

Does it possible to apply only this 2 patches on stable-2.6.32.x and get
working serial consoles?


