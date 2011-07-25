Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab1GYOAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 10:00:12 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:58386 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab1GYOAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 10:00:08 -0400
From: Richard Weinberger <richard@nod.at>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [PATCH] um: disable CMPXCHG_DOUBLE as it breaks UML build
Date: Mon, 25 Jul 2011 16:00:03 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.5; x86_64; ; )
Cc: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>
References: <1311438111-10961-1-git-send-email-cascardo@holoscopio.com>
In-Reply-To: <1311438111-10961-1-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107251600.03311.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 23 Juli 2011, 18:21:51 schrieb Thadeu Lima de Souza Cascardo:
> Commit b789ef518b2a7231b0668c813f677cee528a9d3f tests for cmpxchg_double
> support in the SLUB code and it breaks UML builds with SLUB. Since UML
> does not support checking for CPU features, disable CMPXCHG_DOUBLE just
> like CMPXCHG_LOCAL is disabled for UML.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Jeff Dike <jdike@addtoit.com>
> Cc: Richard Weinberger <richard@nod.at>

Applied!

Thanks,
//richard
