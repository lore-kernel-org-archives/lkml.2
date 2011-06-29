Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab1F2Sx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 14:53:57 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:56185 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752849Ab1F2Sx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 14:53:56 -0400
Date: Wed, 29 Jun 2011 18:53:51 +0000 (UTC)
From: johnlinn@comcast.net
To: linux-kernel@vger.kernel.org
Message-ID: <409519530.22419.1309373631423.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
Subject: using a single sysfs show function for multiple device attributes
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [149.199.62.254]
X-Mailer: Zimbra 6.0.10_GA_2704 (ZimbraWebClient - IE8 (Win)/6.0.10_GA_2697)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a platform driver, I'm trying to use a single function for multiple device attributes and use the attr input to ID which attribute.

After the driver is up and running, the sysfs attributes exist.  In my show function getting a device_attribute as an input, I never see the device attribute (attr) having anything in it (all 0s).  I see the attr pointer be valid, but pointing to all 0's.  

I don't see others using the attr input, but it seems like the way to ID which attribute is being accessed so that one show function can be used for many attributes.

I'm sure it's obvious, but I don't see what I'm doing wrong.

Thanks,
John
