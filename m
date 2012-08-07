Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab2HGIWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 04:22:10 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61357 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab2HGIWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 04:22:08 -0400
MIME-Version: 1.0
X-Originating-IP: [202.62.83.106]
Date: Tue, 7 Aug 2012 13:52:06 +0530
Message-ID: <CANYdXnqCY+Uc=ROvQHv4kRe-g2zoEjfpzV0P83exfXYm-qCBaA@mail.gmail.com>
Subject: A question on serial driver
From: Shashidhar Hiremath <shashidharh@vayavyalabs.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 I have written a console driver where I also do the serial driver
registration and handling. The driver seems to work fine till the
login point(reads and writes). The driver for some reason does not
print the content  I type on console after login prompt. Any reason
why this might be happening ?

--
regards,
Shashidhar Hiremath
