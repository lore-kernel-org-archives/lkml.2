Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209Ab2CaPU5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 11:20:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36933 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760057Ab2CaPUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 11:20:54 -0400
Date: Sat, 31 Mar 2012 19:20:39 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] proc: reset mount options after the last procfs umount
Message-ID: <20120331152039.GA4674@albatros>
References: <201203220903.15360.a.miskiewicz@gmail.com>
 <20120326153738.aa728115.akpm@linux-foundation.org>
 <20120331135520.GB2845@albatros>
 <201203311619.38921.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201203311619.38921.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 16:19 +0200, Arkadiusz Miśkiewicz wrote:
> "after all procs are umounted". For me such way is fine but still can suprise 
> people.
> 
> Anyway - what's the problem with implementing support for separate options for 
> each mount point?

Well, IMHO multiple procs in one pid namespace is a very strange system
configuration.  I didn't see such installations.  Why does anybody need it?

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
