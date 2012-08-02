Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab2HBUcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 16:32:11 -0400
Received: from keetweej.vanheusden.com ([80.101.105.103]:48603 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab2HBUcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 16:32:09 -0400
Date: Thu, 2 Aug 2012 22:32:07 +0200
From: folkert <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: Re: problem with baycom driver - bisect help requested
Message-ID: <20120802203206.GC10211@belle.intranet.vanheusden.com>
References: <20120728213832.GQ7638@belle.intranet.vanheusden.com>
 <20120802200246.GB10211@belle.intranet.vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120802200246.GB10211@belle.intranet.vanheusden.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Fri Aug  3 13:00:19 CEST 2012
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
 key-signing at www.biglumber.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It seems the baycom driver (for ham radio) needs some attention.
> I'm trying to bisect this problem.
> The problem now is, that the 3.1.0-rc9 crashes just after it loads the
> initramfs. Well, it says it is doing that and then all fans speed-up and
> the system locks up.
> What to do now?

This 3.1.0-rc9+ is, by the way, a kernel build on a different amd64
system using fakeroot make dep-pkg

Version 3.0.0-12 (I used an ubuntu kernel image) works fine by the way:
it boots, but it also succeeds in emitting AX.25 data via the baycom
driver.


Folkert van Heusden

-- 
Multitail es una herramienta flexible que permite visualizar los "log
file" y seguir la ejecución de comandos. Permite filtrar, añadir
colores, combinar archivos, la visualización de diferencias (diff-
view), etc.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
