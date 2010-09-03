Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab0ICLNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 07:13:01 -0400
Received: from mx01.bfk.de ([193.227.124.2]:60790 "EHLO mx01.bfk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab0ICLNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 07:13:00 -0400
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Sep 2010 07:13:00 EDT
To: miaox@cn.fujitsu.com
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 2/3] lib: improve the performance of memcpy and memmove of the general version
References: <4C7E2CAC.6080102@cn.fujitsu.com>
From: Florian Weimer <fweimer@bfk.de>
Date: Fri, 03 Sep 2010 11:03:37 +0000
In-Reply-To: <4C7E2CAC.6080102@cn.fujitsu.com> (Miao Xie's message of "Wed\, 01 Sep 2010 18\:36\:28 +0800")
Message-ID: <82mxrzrsvq.fsf@mid.bfk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Miao Xie:

>  EXPORT_SYMBOL(memcpy);

I think you need to change that to EXPORT_SYMBOL_GPL, because the code
is now licensed under the GPL, and not the GPL plus kernel exceptions
(whatever they are, but they undoubtly exist), unlike the original
implementation.

-- 
Florian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstraﬂe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
