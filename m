Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2KMS0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:26:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:52238 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab2KMS0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:26:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,768,1344236400"; 
   d="scan'208";a="219093827"
From: "Li, Sibai" <sibai.li@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Jason Gao <pkill.2012@gmail.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "ddutile@redhat.com" <ddutile@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: SR-IOV problem with Intel 82599EB (not enough MMIO resources
 for SR-IOV)
Thread-Topic: SR-IOV problem with Intel 82599EB (not enough MMIO resources
 for SR-IOV)
Thread-Index: AQHNwaQeM2H6P7Nnnk6rGhmSIf66+Jfn7aEQgACrVID//3vbcA==
Date: Tue, 13 Nov 2012 18:25:58 +0000
Message-ID: <A3A921390EAE4044940E99EBF13D97321AE21FBB@FMSMSX104.amr.corp.intel.com>
References: <201211081915083774239@gmail.com>	<509B962C.6070002@gmail.com>
	<C5551D9AAB213A418B7FD5E4A6F30A072D565E76@ORSMSX106.amr.corp.intel.com>
	<CANmqhJDJXcbUxyt6YD6ktxZCDJ=VqiwhGXP+fLMukQr0o-XwxQ@mail.gmail.com>
	<CAErSpo4xn9t=4yXGLdPQMtUJF=n38tYrMutAoj7NCsLUzQEbcg@mail.gmail.com>
	<CANmqhJAjwP8CLEKpgsDbT-7+n=hf30LbYrTAu+qDH09LzETD4g@mail.gmail.com>
	<A3A921390EAE4044940E99EBF13D97321AE21E15@FMSMSX104.amr.corp.intel.com>
 <CAE9FiQXnP2gpy9z6VNGSpimLkhDYKp6Qr=9nGZ9d-pKdohA4bw@mail.gmail.com>
In-Reply-To: <CAE9FiQXnP2gpy9z6VNGSpimLkhDYKp6Qr=9nGZ9d-pKdohA4bw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
> Yinghai Lu
> Sent: Tuesday, November 13, 2012 10:17 AM
> To: Li, Sibai
> Cc: Jason Gao; bhelgaas@google.com; Rose, Gregory V; ddutile@redhat.com;
> Kirsher, Jeffrey T; linux-kernel; netdev; kvm; e1000-devel@lists.sourceforge.net;
> linux-pci@vger.kernel.org
> Subject: Re: SR-IOV problem with Intel 82599EB (not enough MMIO resources
> for SR-IOV)
> 
> On Tue, Nov 13, 2012 at 8:04 AM, Li, Sibai <sibai.li@intel.com> wrote:
> >
> >>
> >> Thank you very much,I try "pci=realloc" in Centos 6.3,and now it works for
> me.
> >>
> >> thank you Sibai,Our server "Dell R710",its BIOS version is just
> >> v.6.3.0 and release date is 07/24/2012,and I also configured
> >> intel_iommu=on in the grub.conf file,but I can't find these IOMMU
> >> options in "Device Drivers" in my
> >> kernel(2.6.32-279) .config file , btw my os is Centos
> >> 6.3(RHEL6.3),although the problem solved,I'd like to know what's your os
> version ,kernel version?
> >
> > I am using RHEL6.3 with unstable kernel 3.7.0-rc
> 
> that means that config has
> CONFIG_PCI_REALLOC_ENABLE_AUTO=y
> 
> So you don't need to append "pci=realloc"
> 
> Yinghai

Never append "pci=realloc" for both kernel 2.6.32.279 and kernel 3.5.0 above.
