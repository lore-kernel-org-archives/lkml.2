Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934170Ab1IOQK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 12:10:29 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:43409 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934067Ab1IOQK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 12:10:27 -0400
Message-ID: <4E722371.2060908@xenotime.net>
Date: Thu, 15 Sep 2011 09:10:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: import of the kernel-doc tree failed
References: <20110915111301.a4227f9ca0d1f448d54050ae@canb.auug.org.au>
In-Reply-To: <20110915111301.a4227f9ca0d1f448d54050ae@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/11 18:13, Stephen Rothwell wrote:
> Hi Randy,
> 
> Importing the kernel-doc tree today produced this error:
> 
> $ git am ../quilt/kernel-doc/docum-leds-class-fix-typo.patch
> Patch format detection failed.
> 
> I just had to replace the tab in the From: line with a space.

I fixed my version of the patch.

Thanks.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
