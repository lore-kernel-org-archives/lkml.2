Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab2BXSfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 13:35:33 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:55323 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752714Ab2BXSfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 13:35:32 -0500
Message-ID: <4F47D872.8090501@xenotime.net>
Date: Fri, 24 Feb 2012 10:35:30 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Build regressions/improvements in v3.3-rc4
References: <1329769073-10331-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1329769073-10331-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2012 12:17 PM, Geert Uytterhoeven wrote:
> *** ERRORS ***
>
> 61 regressions:
>    + error: "st_register" [drivers/media/radio/wl128x/fm_drv.ko] undefined!:  =>  N/A
>    + error: "st_unregister" [drivers/media/radio/wl128x/fm_drv.ko] undefined!:  =>  N/A

Fix for that should be in media tree -- patch was posted on 2012-FEB-02.

> *** WARNINGS ***
>
> 1253 regressions:
>    + src/fs/cifs/connect.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  =>  2171, 2161, 2153, 2146

Patch for that one is sitting is the cifs git tree.  Was posted on 
2012-JAN-30.


>   + warning: (IMA) selects TCG_TIS which has unmet direct dependencies (TCG_TPM && X86):  => N/A

Will post a possible patch for this one now.


-- 
~Randy
