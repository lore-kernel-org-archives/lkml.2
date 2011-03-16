Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab1CPCzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 22:55:39 -0400
Received: from mail.vyatta.com ([76.74.103.46]:50024 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab1CPCzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:55:37 -0400
Date: Tue, 15 Mar 2011 19:55:34 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: No iproute2 for 2.6.38
Message-ID: <20110315195534.0cc43032@nehalam>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not going to bother releasing for 2.6.38 the only changes
were later reverted.

---
Roopa Prabhu (1):
      iproute2: add VF_PORT support

Stephen Hemminger (3):
      Update to lasest kernel headers
      Revert "iproute2: add VF_PORT support"
      v2.6.38
