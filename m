Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab0F3UgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 16:36:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49024 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab0F3UgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 16:36:22 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Kevin Hilman <davinci-linux-open-source@linux.davincidsp.com>,
       Russell King <linux@arm.linux.org.uk>,
       Sandeep Paulraj <s-paulraj@ti.com>,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
       Steve Chen <schen@mvista.com>, Cyril Chemparathy <cyril@ti.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 02/33] Removing dead ARCH_DAVINCI_TNETV107X
Organization: Deep Root Systems, LLC
References: <cover.1277911345.git.siccegge@cs.fau.de>
	<88ee583babc6f0aecb2238a57644f64159d5c395.1277911346.git.siccegge@cs.fau.de>
Date: Wed, 30 Jun 2010 13:36:16 -0700
In-Reply-To: <88ee583babc6f0aecb2238a57644f64159d5c395.1277911346.git.siccegge@cs.fau.de>
	(Christoph Egger's message of "Wed, 30 Jun 2010 18:05:38 +0200")
Message-ID: <87vd90jm0v.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Egger <siccegge@cs.fau.de> writes:

> ARCH_DAVINCI_TNETV107X doesn't exist in Kconfig, therefore removing
> all references for it from the source code.
>
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

Please leave this define in.

The full support for this platform is currently in linux-next and will
be merged for 2.6.36.

Kevin
