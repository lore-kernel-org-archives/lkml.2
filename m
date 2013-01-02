Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab3ABQKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 11:10:00 -0500
Received: from emvm-gh1-uea09.nsa.gov ([63.239.67.10]:57824 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752783Ab3ABQJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 11:09:56 -0500
X-Greylist: delayed 891 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jan 2013 11:09:56 EST
X-TM-IMSS-Message-ID: <5b6c4b8100091e36@nsa.gov>
Message-ID: <50E4584B.6080805@tycho.nsa.gov>
Date: Wed, 02 Jan 2013 10:54:51 -0500
From: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tamas Lengyel <tamas.lengyel@zentific.com>
CC: konrad.wilk@oracle.com, jeremy@goop.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Access control in Xen privcmd_ioctl_mmap
References: <CAErYnsgFhW3Cf-W1CQJGOUstcyfdQxWUcGkGbd0uxM1R=XYuSw@mail.gmail.com>
In-Reply-To: <CAErYnsgFhW3Cf-W1CQJGOUstcyfdQxWUcGkGbd0uxM1R=XYuSw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2012 03:44 PM, Tamas Lengyel wrote:
> In the privcmd Linux driver two checks in the functions
> privcmd_ioctl_mmap and privcmd_ioctl_mmap_batch are not needed as they
> are trying to enforce hypervisor-level access control.  They should be
> removed as they break secondary control domains when performing dom0
> disaggregation. Xen itself provides adequate security controls around
> these hypercalls and these checks prevent those controls from
> functioning as intended.
> 
> The patch applies to the stable Linux 3.7.1 kernel.

It also applies to (and I have tested it on) 3.8-rc1.

> Signed-off-by: Tamas K Lengyel <tamas.lengyel@zentific.com>
> Cc: Daniel De Graaf <dgdegra@tycho.nsa.gov>
> Cc: xen-devel@lists.xensource.com
> Cc: linux-kernel@vger.kernel.org

Acked-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
