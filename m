Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab1KOKKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 05:10:00 -0500
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:5664 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753959Ab1KOKJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 05:09:57 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host pAFA9UVf005001
Subject: Re: Documentation/input/input.txt.gz has a bug
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: jidanni@jidanni.org
Cc: blp@cs.stanford.edu, linux-kernel@vger.kernel.org
Date: Tue, 15 Nov 2011 11:09:31 +0100
In-Reply-To: <87ipml52ij.fsf@jidanni.org>
References: <87y5vihst7.fsf@blp.benpfaff.org> <87ipml52ij.fsf@jidanni.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1321351772.22548.12.camel@thorin>
Mime-Version: 1.0
X-DCC-x.dcc-servers-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

On Die, 2011-11-15 at 14:21 +0800, jidanni@jidanni.org wrote:
> >>>>> "BP" == Ben Pfaff <blp@cs.stanford.edu> writes:
> BP>     $ ls -l /dev/input/mouse0
> BP>     crw------- 1 root root 13, 32 Nov 12 09:14 /dev/input/mouse0
> Yes, but say there what your are trying to say, or else all we know is
> $ cat /dev/input/mouse0 (c, 13, 32)
> bash: syntax error near unexpected token `('

You plain simply copied too much (and the parentheses also make
absolutely no sense for the "cat" command).
/dev/input/mouse0 is a _c_haracter device with major number _13_ and
minor number _32_.

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

