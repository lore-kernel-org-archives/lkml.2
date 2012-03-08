Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab2CHIj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 03:39:57 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:16687 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab2CHIjy convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 8 Mar 2012 03:39:54 -0500
Message-Id: <4F587E9702000078000770BA@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 08 Mar 2012 08:40:39 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Bjorn Helgaas" <bhelgaas@google.com>, "Yinghai Lu" <yinghai@kernel.org>
Cc: "Bjorn Helgaas" <bjorn.helgaas@gmail.com>, "x86" <x86@kernel.org>,
        "Mauro Carvalho Chehab" <mchehab@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 23/23] x86, PCI: add pcibios_root_rescan
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
 <1331018040-30725-24-git-send-email-yinghai@kernel.org>
 <CAErSpo5TjhNv1W=PxSPO6qXfhW1Mi4dMp83vj82=O_hFOq1vow@mail.gmail.com>
 <CAE9FiQXsY7Dn5TGtD1ARM_KFdz1V1hJOvYAy6e4msM=i3VfhDg@mail.gmail.com>
 <CABhMZUWDngY6jL8jkxQ+SHzEHqTS4i3DqtCD7DUBtL4QS58ovA@mail.gmail.com>
 <CAE9FiQV23maKVMrk7h1cJxYfxrqJcKu7GfwFYUJfSDfh8g-KFQ@mail.gmail.com>
 <CAErSpo5T8-hrtMufDeo_EfupQX3neyoA9ufjN2UYro7-2SXc+Q@mail.gmail.com>
 <CAE9FiQUHm2YOJvoxWZ57AXPcAV7T1QJnFzsWXGNAT160X3Rd6g@mail.gmail.com>
 <CAErSpo6Eh5W7ZB5aZt9fhp3h9EmYTM-vN3yY=0UJauJWY9Tm6w@mail.gmail.com>
In-Reply-To: <CAErSpo6Eh5W7ZB5aZt9fhp3h9EmYTM-vN3yY=0UJauJWY9Tm6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 08.03.12 at 05:27, Bjorn Helgaas <bhelgaas@google.com> wrote:
> Personally, I think we should put a stake in the ground and say "For
> machines newer than 2013, Linux will not blindly probe for PCI
> devices.  If you want EDAC functionality, make sure your BIOS exposes
> the appropriate PCI host bridges."  If OEMs do care about EDAC, it's a
> simple BIOS change to do this.
> 
> I certainly don't think we need to add hotplug or bus rescan
> functionality to cover this case.  This sort of stuff makes
> maintenance MUCH harder because we have to worry about all these
> corner cases.

I'm certainly fine with such a position, as long as this is made visible as
a policy and the other hack in the i7core edac driver to find non-
exposed devices gets removed as well. It was really the existing hack
(which worked only on a certain subset of systems) that made me try
find a more generic solution.

Jan

