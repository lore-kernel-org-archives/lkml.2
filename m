Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab1DLQuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 12:50:05 -0400
Received: from legolas.restena.lu ([158.64.1.34]:55881 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093Ab1DLQuD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 12:50:03 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Apr 2011 12:50:03 EDT
Date: Tue, 12 Apr 2011 18:41:43 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: wzab@ise.pw.edu.pl
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: Screen corrupted in Xorg with KMS on 945GM/GMS, 943/940GML
 chipset with kernel 2.6.38.2
Message-ID: <20110412184143.27dbf34f@neptune.home>
In-Reply-To: <4DA4243A.5030805@ise.pw.edu.pl>
References: <4DA4243A.5030805@ise.pw.edu.pl>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCing intel-gfx]

On Tue, 12 April 2011 Wojciech Zabołotny <wzab@ise.pw.edu.pl> wrote:
> After I've upgraded my kernel to 2.6.38.2, I started to experience very 
> often screen corruption in X (it happened also earlier with 2.6.37.3,
> but now is very often.
> Hardware seems to be OK. I attach  sample screendumps, configuration of 
> my kernel, log of the X server and output of the lspci command.

This looks similar to the xchat corruptions I see (on i855).

Have a look at #34980 (also 945 family) and #35460 on bugs.freedesktop.org.

Bruno
