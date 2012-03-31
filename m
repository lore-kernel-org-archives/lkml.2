Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302Ab2CaPbs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 11:31:48 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59959 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760114Ab2CaPbq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 11:31:46 -0400
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH] proc: reset mount options after the last procfs umount
Date: Sat, 31 Mar 2012 17:31:42 +0200
User-Agent: KMail/1.13.7 (Linux/3.3.0-06972-ge22057c; KDE/4.8.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
References: <201203220903.15360.a.miskiewicz@gmail.com> <201203311619.38921.a.miskiewicz@gmail.com> <20120331152039.GA4674@albatros>
In-Reply-To: <20120331152039.GA4674@albatros>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203311731.42388.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 of March 2012, Vasiliy Kulikov wrote:
> On Sat, Mar 31, 2012 at 16:19 +0200, Arkadiusz Miśkiewicz wrote:
> > "after all procs are umounted". For me such way is fine but still can
> > suprise people.
> > 
> > Anyway - what's the problem with implementing support for separate
> > options for each mount point?
> 
> Well, IMHO multiple procs in one pid namespace is a very strange system
> configuration.  I didn't see such installations. 

I have one real world case - linux-vserver.org guests where pid namespace is 
optional and usually not used.

> Why does anybody need it?

For me current "3.3 +  initial mount options fix" behaviour is fine anyway.

> Thanks,

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
