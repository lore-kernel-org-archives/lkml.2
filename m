Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab1EDMxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 08:53:25 -0400
Received: from mailout.rz.uni-frankfurt.de ([141.2.22.233]:56399 "EHLO
	mailout.rz.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753547Ab1EDMxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 08:53:23 -0400
X-Greylist: delayed 935 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 May 2011 08:53:23 EDT
Message-ID: <4DC14898.8040902@med.uni-frankfurt.de>
Date: Wed, 04 May 2011 14:37:44 +0200
From: Thomas Sattler <sattler@med.uni-frankfurt.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Mnenhy/0.8.3 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.3)
References: <4DAF6C0B.3070009@gmx.de> <20110427134613.GI32590@random.random> <4DC14474.9040001@gmx.de>
In-Reply-To: <4DC14474.9040001@gmx.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again ...

khugepaged just stopped being busy (after more than
three hours). I plugged (and unplugged) USB storage
media just before I noticed it, but this might be
unrelated. And I had no USB media connected when
khugepaged _started_ being busy.

Thomas
