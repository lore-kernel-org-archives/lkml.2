Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab1LPHEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 02:04:54 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:37052 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab1LPHEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 02:04:53 -0500
Message-ID: <4EEAEDCE.3030109@oss.ntt.co.jp>
Date: Fri, 16 Dec 2011 16:05:50 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.24) Gecko/20111103 Thunderbird/3.1.16
MIME-Version: 1.0
To: zanghongyong@huawei.com
CC: linux-kernel@vger.kernel.org, mst@redhat.com, levinsasha928@gmail.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, xiaowei.yang@huawei.com, hanweidong@huawei.com,
        wusongwei@huawei.com
Subject: Re: [PATCH 0/2] vhot-net: Use kvm_memslots instead of vhost_memory
 to translate GPA to HVA
References: <1324013528-3663-1-git-send-email-zanghongyong@huawei.com>
In-Reply-To: <1324013528-3663-1-git-send-email-zanghongyong@huawei.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/12/16 14:32), zanghongyong@huawei.com wrote:
> From: Hongyong Zang<zanghongyong@huawei.com>
> 
> Vhost-net uses its own vhost_memory, which results from user space (qemu) info,
> to translate GPA to HVA. Since kernel's kvm structure already maintains the
> address relationship in its member *kvm_memslots*, these patches use kernel's
> kvm_memslots directly without the need of initialization and maintenance of
> vhost_memory.

Isn't vhost independent from KVM?

	Takuya
