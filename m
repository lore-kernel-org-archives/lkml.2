Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab1KXKWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:22:39 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:50488 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab1KXKWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:22:38 -0500
Message-ID: <4ECE1B20.9040304@oss.ntt.co.jp>
Date: Thu, 24 Nov 2011 19:23:28 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.24) Gecko/20111103 Thunderbird/3.1.16
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 4/6] KVM: introduce id_to_memslot function
References: <4ECE1037.4060300@gmail.com> <4ECE10F8.9070707@gmail.com> <4ECE1948.2060907@oss.ntt.co.jp>
In-Reply-To: <4ECE1948.2060907@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/11/24 19:15), Takuya Yoshikawa wrote:
> (2011/11/24 18:40), Xiao Guangrong wrote:

> You can eliminate this if you use old_slot and new_slot for the two memory slots.

Or old_bitmap and new_bitmap.  Anyway, calling id_to_memslot() for getting the
same slot twice is not good, IMO.

	Takuya
