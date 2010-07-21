Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761600Ab0GUAkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 20:40:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54227 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab0GUAkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 20:40:22 -0400
Message-ID: <4C464102.8020205@cn.fujitsu.com>
Date: Wed, 21 Jul 2010 08:36:18 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/6] KVM: MMU: fix forgot reserved bits check in speculative
 path
References: <4C3FCFD7.5070005@cn.fujitsu.com>
In-Reply-To: <4C3FCFD7.5070005@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Xiao Guangrong wrote:
> In the speculative path, we should check guest pte's reserved bits just as
> the real processor does
> 

Ping......?
