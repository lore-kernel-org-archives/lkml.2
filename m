Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab1LPKNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:13:21 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:54285 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab1LPKNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:13:12 -0500
Message-ID: <4EEB19AF.5070501@linux.vnet.ibm.com>
Date: Fri, 16 Dec 2011 18:13:03 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 0/8] KVM: MMU: reduce the size of shadow page structure and
 some cleanup
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11121610-9574-0000-0000-0000008DC53A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patchset, we observably reduce the size of struct kvm_mmu_page and let
the code more simple.

And this patchset have already tested by unittest and
RHEL.6.1 setup/boot/reboot/shutdown.

