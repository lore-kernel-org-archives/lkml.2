Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030405Ab2HPSXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:23:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030335Ab2HPSW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:22:58 -0400
Message-ID: <502D2247.7060107@redhat.com>
Date: Thu, 16 Aug 2012 19:39:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Alex Williamson <alex.williamson@redhat.com>, gleb@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/6] kvm: level irqfd support
References: <20120810223633.809.44188.stgit@bling.home> <20120815142803.GF3068@redhat.com> <1345052191.4683.435.camel@ul30vt.home> <20120815192224.GB5670@redhat.com> <502D1FF4.20506@redhat.com> <20120816163658.GA22518@redhat.com>
In-Reply-To: <20120816163658.GA22518@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 07:36 PM, Michael S. Tsirkin wrote:

>> What if a level irqfd shares a line with a KVM_IRQ_LINE ioctl?  Then an
>> EOI can de-assert the irqfd source, but the line is kept high by the
>> last KVM_IRQ_LINE invocation.
> 
> Exactly. So 1 ID for userspace and 1 for irqfd.

Gaa, this mess belongs in userspace.

-- 
error compiling committee.c: too many arguments to function
