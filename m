Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab0EGD61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 23:58:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59076 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab0EGD60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 23:58:26 -0400
Message-ID: <4BE38F22.9010509@cn.fujitsu.com>
Date: Fri, 07 May 2010 11:55:14 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/9] KVM MMU: allow more shadow pages become asynchronous
References: <4BE28C2A.1050809@cn.fujitsu.com>
In-Reply-To: <4BE28C2A.1050809@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Marcelo,

patch 5 and patch 6 are can't apply to current kvm tree, i'll
rebase those two patches.

Marcelo, does this patchset fix your issue? I have tested it with
Fedora12/Ubuntu/CentOS 32/64 guests, it works well.

Thanks,
Xiao
