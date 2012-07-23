Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab2GWODa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 10:03:30 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:40290 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab2GWOD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 10:03:29 -0400
Message-ID: <500D59A7.9060503@linux.vnet.ibm.com>
Date: Mon, 23 Jul 2012 22:03:19 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 0/3] KVM: remove dummy pages
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072314-4790-0000-0000-000003D111BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, kvm allocates some pages and use then as error indicators,
it wastes memory and is not good for scalability.

In this patchset, we introduce some error code instead of the pages to
indicate the error conditions.

