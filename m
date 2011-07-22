Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1GVGAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 02:00:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab1GVGA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 02:00:29 -0400
Date: Fri, 22 Jul 2011 09:00:46 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mashirle@us.ibm.com, mst@redhat.com,
        xma@us.ibm.com
Subject: [PULL net] vhost-net: zercopy mode fixes
Message-ID: <20110722060046.GA8876@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following includes vhost-net fixes - both in the
experimental zero copy mode.
Please pull for 3.1.
Thanks!


