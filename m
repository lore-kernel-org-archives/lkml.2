Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab2JPGWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 02:22:11 -0400
Received: from shiva.jussieu.fr ([134.157.0.129]:55214 "EHLO shiva.jussieu.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab2JPGWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 02:22:10 -0400
X-Ids: 165
From: Juliusz Chroboczek <jch@pps.jussieu.fr>
To: Jochen Striepe <jochen@tolot.escape.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Write is not atomic?
References: <7i391fto34.fsf@lanthane.pps.jussieu.fr>
	<20121015234006.GK2842@pompeji.miese-zwerge.org>
Date: Tue, 16 Oct 2012 08:21:35 +0200
In-Reply-To: <20121015234006.GK2842@pompeji.miese-zwerge.org> (Jochen
	Striepe's message of "Tue, 16 Oct 2012 01:40:06 +0200")
Message-ID: <7ia9vn3pjk.fsf@lanthane.pps.jussieu.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Miltered: at jchkmail.jussieu.fr with ID 507CFCF0.004 by Joe's j-chkmail (http : // j-chkmail dot ensmp dot fr)!
X-j-chkmail-Enveloppe: 507CFCF0.004/134.157.168.1/hydrogene.pps.jussieu.fr/hydrogene.pps.jussieu.fr/<jch@pps.jussieu.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This seems out of context.

>       If the file was open(2)ed with O_APPEND, the file offset is first
>       set to the end of the file before writing.  The adjustment of the
>       file offset and the write operation are performed as an atomic
>       step.

> Sounds different, doesn't it?

Yes, it does -- thanks for the clarification.  (And thanks to Dave for
the interesting tests.)

Sorry for the confusion,

-- Juliusz
