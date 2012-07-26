Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab2GZD5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 23:57:08 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:42001 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2GZD5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 23:57:06 -0400
Message-ID: <5010C008.4030304@linux.vnet.ibm.com>
Date: Thu, 26 Jul 2012 11:56:56 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 0/3] KVM: remove dummy pages
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072603-7014-0000-0000-0000019FBE21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
  correct some typos in the title/changelog.

Currently, kvm allocates some pages (e.g: bad_page/fault_page) and use them
as error indicators, it wastes memory and is not good for scalability.

Base on Avi's suggestion, in this patchset, we introduce some error codes
instead of these pages to indicate the error conditions.

