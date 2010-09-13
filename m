Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab0IMUnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:43:09 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38424 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101Ab0IMUnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:43:07 -0400
Subject: [RFC PATCH 0/1] macvtap TX zero copy between guest and host kernel
From: Shirley Ma <mashirle@us.ibm.com>
To: Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>, mst@redhat.com
Cc: xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 13:43:00 -0700
Message-ID: <1284410580.13351.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch induces a new sock flag ZEROCOPY to avoid copy between
userspace and kernel. macvtap is the first user of zero copy between
guest and host kernel. It only uses when the lower device supports high
memory DMA. The first set of patch only addresses transmission TX side.
The test has shown big improvement on either CPU utilization reduction
or BW increase on 10GbE Intel NIC. Performance data will be submitted in
the coming email.

thanks
Shirley

