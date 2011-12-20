Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab1LTJTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 04:19:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab1LTJTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 04:19:16 -0500
Message-ID: <4EF0530F.3050309@redhat.com>
Date: Tue, 20 Dec 2011 11:19:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH 1/2] kvm: Remove ability to assign a device without iommu
 support
References: <20111220030826.11829.9141.stgit@bling.home> <20111220031947.11829.66292.stgit@bling.home>
In-Reply-To: <20111220031947.11829.66292.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 05:19 AM, Alex Williamson wrote:
> This option has no users and it exposes a security hole that we
> can allow devices to be assigned without iommu protection.  Make
> KVM_DEV_ASSIGN_ENABLE_IOMMU a mandatory option.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>
>  virt/kvm/assigned-dev.c |   18 +++++++++---------
>
Documentation/virtual/kvm/api.txt +++

-- 
error compiling committee.c: too many arguments to function

