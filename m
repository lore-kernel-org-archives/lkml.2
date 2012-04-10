Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab2DJLU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 07:20:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54224 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab2DJLU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 07:20:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: dl8bcu@dl8bcu.de, Dave Jones <davej@redhat.com>
Subject: Re: No more Linux 2.4 releases
Date: Tue, 10 Apr 2012 11:20:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
References: <20120409133050.GA17473@1wt.eu> <201204091522.38021.arnd@arndb.de> <20120409204816.GB1073@ds20.borg.net>
In-Reply-To: <20120409204816.GB1073@ds20.borg.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204101120.36338.arnd@arndb.de>
X-Provags-ID: V02:K0:+EXNUlEOhD41lIW/GoWDbweNbZaEOgwW1pkhrpDT0dA
 2er23BZx6tA3P8iX8K1NYVLS1L2WHux/3qx0JN4lRox5FdRJaM
 ZYXPICqONwiZgFNbxJ1ATV3lKqnHKR98qQOvAI/ALxO64ZGKam
 +pggIwevd2HhLXbuHSqsa9M0G2DTCOPh4DL1A6rz3RcPZ8CykJ
 asyrc0Jn1WH6fQYqIkfVjFCHEiQ/UbtrBGmC7SKPA735t3EpmZ
 ox2j9tr+2YjgafAfnlXNhto1yBCGZ/vGmi8GRTjsOmboAaagWh
 fVU1MBJmgjct62qrWqlnCmtxY6yf5SeepM5vTIWlNeMYn4+P9p
 8KQqV2jZZs7wOtDTEdek=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2012, Thorsten Kranzkowski wrote:
> On Mon, Apr 09, 2012 at 03:22:37PM +0000, Arnd Bergmann wrote:
> > 
> > I'm still looking for a copy of the "historic" kernels that we used
> > to have on kernel.org, but that's not your problem.
> 
> I recently found something here:
> 
> http://147.52.159.12/mirrors/ftp.kernel.org/pub/scm/linux/kernel/git/davej/history.git
> http://147.52.159.12/mirrors/ftp.kernel.org/pub/scm/linux/kernel/git/torvalds/old-2.6-bkcvs.git

Ok, thanks,

While the archive.org repository that Dave mentioned has a good history leading
up to v2.6.12, these ones add the stable branches (v2.4, v2.2, v2.0, ...) and
the missing tags. I think I've got it all now.

	Arnd
