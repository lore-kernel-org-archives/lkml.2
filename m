Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab1LTJOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 04:14:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab1LTJOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 04:14:18 -0500
Message-ID: <4EF051E3.20101@redhat.com>
Date: Tue, 20 Dec 2011 11:14:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Sasha Levin <levinsasha928@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kvm: Remove ability to assign a device without iommu
 support
References: <20111220030826.11829.9141.stgit@bling.home>   <20111220031947.11829.66292.stgit@bling.home>  <1324370959.22797.3.camel@lappy> <4EF04F54.9010500@siemens.com> <1324372128.22797.6.camel@lappy> <4EF0516F.2030102@siemens.com>
In-Reply-To: <4EF0516F.2030102@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 11:12 AM, Jan Kiszka wrote:
> > 
> > Well, Alex suggested skipping deprecation period because there are
> > currently no users of KVM_ASSIGN_PCI_DEVICE without
> > KVM_DEV_ASSIGN_ENABLE_IOMMU, so it should be fine to just make it the
> > default behavior, no?
>
> This iommu-less mode used to "work" for older qemu-kvm version, and I
> think it should still do. Though it makes no sense, I fully agree.
>

It only worked for special kernels that allowed 1:1 gpa/hpa mappings, IIRC.

-- 
error compiling committee.c: too many arguments to function

