Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab2FYNcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 09:32:08 -0400
Received: from mailout.rz.uni-frankfurt.de ([141.2.22.233]:37697 "EHLO
	mailout.rz.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756365Ab2FYNcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 09:32:07 -0400
X-Greylist: delayed 2025 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jun 2012 09:32:07 EDT
Message-ID: <4FE86067.9010408@med.uni-frankfurt.de>
Date: Mon, 25 Jun 2012 14:58:15 +0200
From: Thomas Sattler <sattler@med.uni-frankfurt.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: scheduling while atomic: chcpu/6197/0x00000002
References: <4FDF00CB.7090703@med.uni-frankfurt.de> <4FDF201E.2090408@med.uni-frankfurt.de> <4FE19494.6000303@med.uni-frankfurt.de>
In-Reply-To: <4FE19494.6000303@med.uni-frankfurt.de>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again ...

seems there is a little progress in 3.4.3-rt12-rc1: While
the BUG message still is in 'dmesg' and the call trace is
identical to 3.4.3-rt11 (except the PID of 'chcpu' and
the order of the list of modules), the 'chcpu' process
doesn't hang anymore and the machine can be rebooted
after the BUG occured.

Thomas
