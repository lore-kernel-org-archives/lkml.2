Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933837Ab1JZScq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 14:32:46 -0400
Received: from inti.inf.utfsm.cl ([200.1.19.1]:25859 "EHLO inti.inf.utfsm.cl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932790Ab1JZScn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 14:32:43 -0400
X-Greylist: delayed 1064 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Oct 2011 14:32:43 EDT
Message-Id: <201110261814.p9QIEuwH005829@laptop15.inf.utfsm.cl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 3.1 hang on Intel(R) Core(TM) i5 CPU M 430@2.27GHz) with nVidia GT218 [GeForce 310M] (rev a2)
X-Mailer: MH-E 7.4.2; nmh 1.3; XEmacs 21.5  (beta31)
Date: Wed, 26 Oct 2011 15:14:56 -0300
From: "Horst H. von Brand" <vonbrand@inf.utfsm.cl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The above combination with Fedora 15 up to date (x86_64) hangs frequently
(did hang trice during today's morning). 3.1-rc9 and -rc10 did behave,
older -rc did hang once a day or two.

Kernel compiled with essentially the Fedora kernel configuration.
-- 
Dr. Horst H. von Brand                   User #22616 counter.li.org
Departamento de Informatica                    Fono: +56 32 2654431
Universidad Tecnica Federico Santa Maria             +56 32 2654239
Casilla 110-V, Valparaiso, Chile 2340000       Fax:  +56 32 2797513
