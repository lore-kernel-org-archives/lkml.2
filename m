Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1FOHQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 03:16:53 -0400
Received: from fep14.mx.upcmail.net ([62.179.121.34]:36445 "EHLO
	fep14.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab1FOHQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 03:16:52 -0400
X-SourceIP: 178.83.226.131
Message-ID: <4DF85C5F.4080307@odi.ch>
Date: Wed, 15 Jun 2011 09:16:47 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: 2.6.39.1 input regression
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=CqMFsqQC4gx7bBgpmnW/wKYuJF/a5pXPeCAfngFtYkU= c=1 sm=0 a=c6weS0ZJO8EA:10 a=eIhxMilvRf8A:10 a=8nJEP1OIZ-IA:10 a=Ewiv-e9z5UFrI8ufQf4A:9 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This patch in 2.6.39.1 breaks magicmouse support for me completely.
a5ccaac64c17ce3cc1878a6d479a6f1b16092c24
HID: magicmouse: ignore 'ivalid report id' while switching modes

The device will no longer work at all:
magicmouse 0005:05AC:030D.0005: input,hidraw2: BLUETOOTH HID v0.84 Mouse
[gandalf mouse] on 7C:6D:62:9F:DB:2D
magicmouse 0005:05AC:030D.0005: unable to request touch data (2)

Fine in previous kernels.

Thanks.

Ortwin
