Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab0F1Jxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 05:53:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64875 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab0F1Jxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 05:53:44 -0400
Message-ID: <4C287047.7080805@cn.fujitsu.com>
Date: Mon, 28 Jun 2010 17:49:59 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/10] KVM: MMU: fix conflict access permissions in
 direct sp
References: <4C2498EC.2010006@cn.fujitsu.com> <4C249B93.9040907@cn.fujitsu.com> <4C286ECA.1030806@redhat.com>
In-Reply-To: <4C286ECA.1030806@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:

>>    
> 
> Looks good, but please split the cleanup from the fix (we'll want to
> backport the fix but not the cleanup).
> 

OK, will do it

