Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab1JXMFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:05:40 -0400
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:32857 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932076Ab1JXMFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:05:39 -0400
Message-ID: <4EA549C3.4080206@ntlworld.com>
Date: Mon, 24 Oct 2011 12:19:31 +0100
From: nick bray <nick.bray1@ntlworld.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel panic
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=KyjcROdnNc8A:10 a=uObrxnre4hsA:10 a=8nJEP1OIZ-IA:10 a=I5KzmUk7OcGxrGpR7PkA:9 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  after upgrading to linux kernel 3.xx I get kernel panic on boot unless 
I use ACPI=off in the boot parameters this happens with both Ubuntu 
11.10 and Fedora 16. The mainboard is an Intel S875WP1-E running a 
Pentuim 4 3ghz with 3gig RAM in single-channel mode. I have performed a 
Bios upgrade just in case tha ACPI tables were corrupt but it makes no 
difference. Currently running 2.6.38-11-generic #50-Ubuntu SMP (Linux 
Mint) with no issues. I can provide a screenshot if you wish but it's 
looking like it's ACPI related as above.

Yours sincerely

Nick Bray
