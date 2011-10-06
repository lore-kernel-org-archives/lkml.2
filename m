Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965172Ab1JFRGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:06:00 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:60607 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965078Ab1JFRF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:05:59 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Adrian Bunk <bunk@stusta.de>
Cc: Valdis.Kletnieks@vt.edu, "Frank Ch. Eigler" <fche@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
References: <4E8655CD.90107@zytor.com> <201110020304.28288.rjw@sisk.pl>
	<4E87B885.50005@zytor.com> <201110021354.57995.rjw@sisk.pl>
	<4E88A537.4010008@zytor.com>
	<20111003093239.GB25136@localhost.pp.htv.fi>
	<y0mobxyjazi.fsf@fche.csb> <20111003180441.GD3072@localhost.pp.htv.fi>
	<34045.1317760188@turing-police.cc.vt.edu>
	<20111004223932.GA3460@localhost.pp.htv.fi>
Date: Thu, 06 Oct 2011 19:05:54 +0200
In-Reply-To: <20111004223932.GA3460@localhost.pp.htv.fi> (Adrian Bunk's
	message of "Wed, 5 Oct 2011 01:39:32 +0300")
Message-ID: <m34nzmcaod.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> writes:

> If you just want to be sure that patch number 100 comes from the same
> person as the 99 patches before you could do that without key signing
> (require signed patches and check that all 100 patches were signed by
>  the same key).

This leaves room for MITM attacks. The attacked can remove the original
signature and add his own.
-- 
Krzysztof Halasa
