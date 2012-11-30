Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab2K3Wct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 17:32:49 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63424 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab2K3Wcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 17:32:47 -0500
MIME-Version: 1.0
X-Originating-IP: [69.204.246.183]
Date: Fri, 30 Nov 2012 17:32:47 -0500
X-Google-Sender-Auth: YS-lDi1q5aoBD7fI-tmf0Vyar1E
Message-ID: <CAAEK+QPm1mq+t5xXcMNQF3SggPy3bFJCFOi8Fp7bjWAeJYHCZw@mail.gmail.com>
Subject: Record/Replay implementation (as opposed to checkpoint/restart)
From: Nicolas Viennot <nicolas@viennot.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear hackers,

I built scribe, a record/replay engine implemented in the kernel.

If you want to explore the code,
here it is: git://github.com/nviennot/linux-2.6-scribe.git
most of it is in the ./scribe directory.
Warning: contains time-space continuum bending material

Additionally, here is a blog post that introduce it in further details
(includes a screencast):
http://velvetpulse.com/2012/11/27/scribe-the-deterministic-transparent-record-replay-engine/

Cheers,
Nico
