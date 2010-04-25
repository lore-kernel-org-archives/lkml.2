Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab0DYHB2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 03:01:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62922 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab0DYHB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 03:01:27 -0400
Message-ID: <4BD3E809.3060907@cn.fujitsu.com>
Date: Sun, 25 Apr 2010 14:58:17 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/10] KVM MMU: allow more shadow pages become asynchronous
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changlog v2:

- when level is PT_DIRECTORY_LEVEL, the 'offset' should be
  'role.quadrant << 8', thanks Avi for point it out

- keep invlpg code in paging_tmpl.h address Avi's suggestion

- split kvm_sync_page() into kvm_sync_page() and kvm_sync_page_transient()
  to clarify the code address Avi's suggestion
