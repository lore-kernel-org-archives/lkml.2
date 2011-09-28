Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab1I1I1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:27:54 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:6351 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab1I1I1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:27:52 -0400
Message-ID: <4E82DA79.70006@atmel.com>
Date: Wed, 28 Sep 2011 10:27:37 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: at91 material for 3.1
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

I have two little patches about Kconfig and one defconfig that are
suitable for a 3.1 inclusion.

I wonder if you plan a pull request to Linus before 3.1-final?

If yes, would you prefer each patch in a feature branch on its own
(at91-kconfig, at91-defconfig for instance) or a generic at91-fixes?

Thanks, best regards,
-- 
Nicolas Ferre

