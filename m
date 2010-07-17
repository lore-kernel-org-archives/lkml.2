Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab0GQIpq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 04:45:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45436 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab0GQIpp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 04:45:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Yq7a02W7kvHv0rUS2Osb4eXm4IlL1+CTAoI3lorU6epz528Th3g+cCnQM8ISWykV/r
         lRgA/cIbOqAyvSqa/HWq6eVZvSVwzioqoLBo6MIXk1/YKSU7OnU8x9DvCrRX1GnKcfHy
         +WMe0Vs8ltAwwrmQGxlNrj06PVQEIQHMYbo44=
MIME-Version: 1.0
In-Reply-To: <4c40d618./j7HFMCg9NusCIiB%pugs@cisco.com>
References: <4c40d618./j7HFMCg9NusCIiB%pugs@cisco.com>
From: =?UTF-8?Q?Piotr_Jaroszy=C5=84ski?= <p.jaroszynski@gmail.com>
Date: Sat, 17 Jul 2010 10:45:23 +0200
Message-ID: <AANLkTin4aU9GtC8zOuQcCRAQsWb_ndih3c6URlpE4ODI@mail.gmail.com>
Subject: Re: [PATCH V3] VFIO driver: Non-privileged user level PCI drivers
To: Tom Lyon <pugs@cisco.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, randy.dunlap@oracle.com,
        arnd@arndb.de, chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de,
        avi@redhat.com, gregkh@suse.de, alex.williamson@redhat.com,
        mst@redhat.com, aafabbri@cisco.com, scofeldm@cisco.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 July 2010 23:58, Tom Lyon <pugs@cisco.com> wrote:
> The VFIO "driver" is used to allow privileged AND non-privileged processes to
> implement user-level device drivers for any well-behaved PCI, PCI-X, and PCIe
> devices.

Thanks for working on that! I wonder whether it's possible to say what
are the chances of it being merged to mainline and which version we
might be talking about?

-- 
Best Regards
Piotr Jaroszyński
