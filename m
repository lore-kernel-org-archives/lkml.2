Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab1KHDKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 22:10:46 -0500
Received: from smtp27.mail.ru ([94.100.176.180]:53896 "EHLO smtp27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab1KHDKp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 22:10:45 -0500
Date: Tue, 8 Nov 2011 11:10:36 +0800
From: Daniil Stolnikov <danila.st@mail.ru>
Reply-To: Daniil Stolnikov <danila.st@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <92909814.20111108111036@mail.ru>
To: linux-kernel@vger.kernel.org
CC: netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        <linux-security-module@vger.kernel.org>, <davem@davemloft.net>
Subject: Add IPSec IP Range in Linux kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8BIT
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Found that the stack IPSec in Linux does not support any IP range. Many people ask this question. The archives say strongswan said that their daemon supports a range, but the Linux IPSec stack supports only the subnets. I am writing to you to implement support for IP range in Linux. I think that a lot more people will appreciate this innovation.


Regards
Daniil Stolnikov.

