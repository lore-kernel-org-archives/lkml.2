Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2JVPgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:36:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab2JVPgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:36:47 -0400
Message-ID: <50856804.5030408@redhat.com>
Date: Mon, 22 Oct 2012 17:36:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix vcpu->mmio_fragments overflow
References: <20121022114311.GQ29310@redhat.com> <508531E1.2030307@siemens.com> <508539A8.40404@redhat.com> <50853FF1.8010809@siemens.com> <20121022125301.GS29310@redhat.com> <50854232.8090309@siemens.com> <508542EF.5050401@redhat.com> <508544B6.6070301@siemens.com> <20121022130810.GW29310@redhat.com> <5085495D.6060307@siemens.com> <20121022140056.GY29310@redhat.com>
In-Reply-To: <20121022140056.GY29310@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 04:00 PM, Gleb Natapov wrote:
> Yes, with frame buffer is seems to be the case. One can imagine ROMD
> device that is MMIO on write but still can be accessed for read from
> kernel, but it cannot be coalesced even if coalesced buffer is flushed
> on every exit.

You cannot enable coalescing on such a device.


-- 
error compiling committee.c: too many arguments to function
