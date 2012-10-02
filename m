Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab2JBToK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 15:44:10 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:60122 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207Ab2JBToH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 15:44:07 -0400
Message-ID: <506B4404.20100@msgid.tls.msk.ru>
Date: Tue, 02 Oct 2012 23:44:04 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes for 3.7
References: <20121002194053.GA11100@havoc.gtf.org>
In-Reply-To: <20121002194053.GA11100@havoc.gtf.org>
X-Enigmail-Version: 1.4.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.10.2012 23:40, Jeff Garzik wrote:

> Minor libata updates, nothing notable.
> 
> 1) Apply -- and then revert -- the FUA feature.  Caused
>    disk corruption in linux-next, proving it cannot be turned on by
>    default.

Any details on that?  Disk corruprion is rather a nasty
side-effect indeed.

Thank you!

/mjt
