Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab0HCLGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 07:06:42 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:47575 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421Ab0HCLGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 07:06:40 -0400
X-Greylist: delayed 808 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Aug 2010 07:06:40 EDT
X-ASG-Debug-ID: 1280832789-710700000000-xx1T2L
X-Barracuda-URL: http://10.101.1.181:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4C57F512.5050509@fusionio.com>
Date: Tue, 3 Aug 2010 12:53:06 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Chirag Kantharia <chirag.kantharia@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        "iss_storagedev@hp.com" <iss_storagedev@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-ASG-Orig-Subj: Re: [PATCH] cpqarray: check put_user() result
Subject: Re: [PATCH] cpqarray: check put_user() result
References: <1280418885-5630-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1280418885-5630-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1280832789
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at fusionio.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-29 17:54, Kulikov Vasiliy wrote:
> put_user() may fail, if so return -EFAULT.

Applied.

-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.
