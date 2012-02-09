Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab2BIJZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 04:25:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab2BIJZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 04:25:24 -0500
Message-ID: <4F3390FB.80107@redhat.com>
Date: Thu, 09 Feb 2012 10:25:15 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Christian Hoff <christian.hoff@de.ibm.com>,
        James Bottomley <JBottomley@parallels.com>
CC: BORNTRAE@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        mst@redhat.com, rusty@rustcorp.com.au
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
References: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com> <4F30F4EE.4080607@redhat.com> <4F311154.9080407@de.ibm.com> <4F3119A0.7080005@redhat.com> <4F312492.1040002@de.ibm.com> <OFAFB86CAE.9917478D-ONC125799D.004AF231-C125799D.004CE6D2@de.ibm.com> <4F313526.2050907@redhat.com> <OF36197712.1A42EB9E-ONC125799E.0049E3C2-C125799E.004AD4BF@de.ibm.com>
In-Reply-To: <OF36197712.1A42EB9E-ONC125799E.0049E3C2-C125799E.004AD4BF@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 02:37 PM, Christian Hoff wrote:
> Again, I have already done much testing with virtio-scsi and can confirm
> that the code is working flawlessly. In my opinion, virtio-scsi is a
> worthwhile addition to virtio-block and should be considered for inclusion
> into mainline kernel code.

Thank you very much!

James, will you include virtio-scsi in 3.4?

Thanks,

Paolo
