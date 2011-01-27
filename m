Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1A0MeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 07:34:25 -0500
Received: from vamos2c.informatik.uni-erlangen.de ([131.188.42.15]:42657 "EHLO
	vamos2c.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754541Ab1A0MeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 07:34:21 -0500
X-Greylist: delayed 2290 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jan 2011 07:34:21 EST
From: Reinhard Tartler <Reinhard.Tartler@informatik.uni-erlangen.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: vamos@i4.informatik.uni-erlangen.de, Julia Lawall <julia@diku.dk>
Subject: [ANNOUNCE] undertaker 1.0
Organization: Uni Erlangen, Informatik 4, Lehrstuhl =?utf-8?Q?f=C3=BCr?=
 Betriebs- und verteilte Systeme
X-Url: http://www4.informatik.uni-erlangen.de/~tartler
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	vamos@i4.informatik.uni-erlangen.de, Julia Lawall <julia@diku.dk>
Date: Thu, 27 Jan 2011 12:56:07 +0100
Message-ID: <87y666tvag.fsf@faui44a.informatik.uni-erlangen.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The VAMOS team is pleased to announce the first release of undertaker 1.0.
The undertaker tool is a result of the VAMOS[1] research project.
Please visit our project site at:

http://vamos.informatik.uni-erlangen.de/trac/undertaker

What is undertaker?
-------------------

The undertaker is a tool for static code analysis for code with C
preprocessor directives, which can be used in various modes. The most
prominent one checks every single preprocessor block within the file
whether it can be selected or deselected, which in many cases is a great
asset for code maintenance.

Some preprocessor blocks are only seemingly conditional. In many cases,
it turns out that additional constraints from the project's configuration
model causes such conditional blocks to be in fact unconditionally selected
or unselected. We call such block "dead" and "undead" conditional blocks.

Undertaker provides tools to extract the configuration model from
the Linux configuration tooling Kconfig and to perform this check on whole
source trees.

We have already performed a check on the v2.6.38-rc1 tree and provide
easy access to the results via an online interface[2]. There is also a cpio
archive with the report files.

What undertaker is not?
-----------------------

It isn't an automatic patch generator. Because of peculiarities in the
Kconfig semantics, (ignored) coding guidelines and simply engineering
issues, the reports might contain false negatives. Note that our
philosophy is that we prefer false negatives over false positives, i.e.,
we prefer to miss reports than reports that are no issue at all.

What else can i do with undertaker?
-----------------------------------

You can extract boolean formulas (with or without model) for a given
line of sourcecode in a file or for a given symbol. There is also an
integration for emacs for interactive browsing of block and symbol
preconditions.

Additional uses are currently under development.

[1] http://www4.informatik.uni-erlangen.de/Research/VAMOS/
[2] http://www4.informatik.uni-erlangen.de/Research/VAMOS/linux-trees/

-- 
Reinhard Tartler                     Department of Computer Science IV
Martensstr 1, 91058 Erlangen Germany, University of Erlangen-Nuremberg
            http://www4.informatik.uni-erlangen.de/~tartler
