Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2JOTlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 15:41:35 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44679 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab2JOTld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 15:41:33 -0400
Message-ID: <507C66E0.6070802@gmail.com>
Date: Mon, 15 Oct 2012 21:41:20 +0200
From: "Mikko C." <mikko.cal@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel panic on CentOS
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
we keep getting kernel panics on our CentOS 6.3 server, running about 40 
KVM virtual machines.

Here's the screenshot of the trace: http://i.imgur.com/yaRyF.png

# uname -a
Linux srv010 2.6.32-71.el6.x86_64 #1 SMP Fri May 20 03:51:51 BST 2011 
x86_64 x86_64 x86_64 GNU/Linux

CPU is Intel i7-2600K with 32GB DDR3 ram.

If there's any more info we can provide, please let me know.
Thanks
Mikko
