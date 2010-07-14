Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab0GNOmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 10:42:21 -0400
Received: from peer.zerties.org ([188.40.33.175]:46647 "EHLO peer.zerties.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab0GNOmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 10:42:20 -0400
X-Greylist: delayed 1519 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jul 2010 10:42:19 EDT
From: Christian Dietrich <stettberger@dokucode.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>,
        Rajendra Nayak <rnayak@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 1/5] drivers/regulator: Remove dead CONFIG_TWL4030_ALLOW_UNSUPPORTED
References: <c3c850bed3f5714f1efcfad24ad4f8bfcb6b5b54.1279116162.git.qy03fugy@stud.informatik.uni-erlangen.de>
	<20100714141108.GC31073@rakim.wolfsonmicro.main>
Date: Wed, 14 Jul 2010 16:16:46 +0200
In-Reply-To: <20100714141108.GC31073@rakim.wolfsonmicro.main> (Mark Brown's
	message of "Wed, 14 Jul 2010 15:11:08 +0100")
Message-ID: <86fwzmm9m9.fsf@peer.zerties.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown <broonie@opensource.wolfsonmicro.com> writes:

> On Wed, Jul 14, 2010 at 04:04:28PM +0200, Christian Dietrich wrote:
>> CONFIG_TWL4030_ALLOW_UNSUPPORTED doesn't exist in Kconfig and is never
>> defined anywhere else, therefore removing all references for it from
>> the source code.
>> 
>> Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
>
> Nack, you're missing the point of having this code here.

So if it isn't a config option, then perhaps it should be named CONFIG_?

-- 
(λ x . x x) (λ x . x x) -- See how beatiful the lambda is
No documentation is better than bad documentation

