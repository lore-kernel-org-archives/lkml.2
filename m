Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab0H2L7G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 07:59:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:36812 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab0H2L7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 07:59:04 -0400
Message-ID: <4C7A49F9.1030400@kernel.org>
Date: Sun, 29 Aug 2010 13:52:25 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: CAI Qian <caiqian@redhat.com>
CC: torvalds@linux-foundation.org, linux-next@vger.kernel.org,
        kexec <kexec@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kdump regression compared to v2.6.35
References: <1236896997.1479691283083005518.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1236896997.1479691283083005518.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 29 Aug 2010 11:58:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2010 01:56 PM, CAI Qian wrote:
> It is easy to reproduce by passing maxcpus=1 to the first kernel.

Do you mean booting w/ maxcpus=1 hangs the first kernel even w/o
kdump?

Thanks.

-- 
tejun
