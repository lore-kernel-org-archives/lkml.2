Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab0GULpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 07:45:30 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:47826 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753106Ab0GULp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 07:45:28 -0400
Date: Wed, 21 Jul 2010 13:45:26 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, Eric Miao <eric.y.miao@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Magnus Damm <damm@opensource.se>, Karsten Keil <keil@b1-systems.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Steven A. Falco" <sfalco@harris.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH] Remove dead CONFIG_PCMCIA_IOCTL
Message-ID: <20100721114526.GA13082@isilmar-3.linta.de>
Mail-Followup-To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>,
	Ralf Baechle <ralf@linux-mips.org>,
	Eric Miao <eric.y.miao@gmail.com>,
	Marek Vasut <marek.vasut@gmail.com>,
	Manuel Lauss <manuel.lauss@gmail.com>,
	Magnus Damm <damm@opensource.se>, Karsten Keil <keil@b1-systems.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Steven A. Falco" <sfalco@harris.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
	vamos-dev@i4.informatik.uni-erlangen.de
References: <20100721113710.GA7724@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100721113710.GA7724@faui49.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, Jul 21, 2010 at 01:37:10PM +0200, Christian Dietrich wrote:
> CONFIG_PCMCIA_IOCTL doesn't exist in Kconfig, therefore removing all
> references for it from the source code. PCMCIA_IOCTL was removed partly
> in a3f916f2c84f2b9e1d32cc0dbfe326a9e380dbfb, but there were a few pieces
> scattered over the source tree, because they are never selected they can
> be removed.

the code is still in there on purpose -- it is only scheduled for removal
for 2.6.36. See Documentation/feature-removal-schedule.txt for details. For
2.6.36, I've already applied a patch to the PCMCIA tree, which you may find
at http://git.kernel.org/?p=linux/kernel/git/brodo/pcmcia-2.6.git;a=summary
(gitweb).

Best,
	Dominik
