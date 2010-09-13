Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab0IMIQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:16:47 -0400
Received: from ist.d-labs.de ([213.239.218.44]:41781 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652Ab0IMIQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:16:45 -0400
Date: Mon, 13 Sep 2010 10:16:43 +0200
From: Florian Mickler <florian@mickler.org>
To: Tejun Heo <tj@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH UPDATED] workqueue: add documentation
Message-ID: <20100913101643.22a1e7d5@schatten.dmk.lab>
In-Reply-To: <4C8DDBEC.3010900@kernel.org>
References: <4C87AE52.70401@kernel.org>
	<4C87B101.2080608@kernel.org>
	<20100909100229.250900f0@schatten.dmk.lab>
	<4C88B55E.90203@kernel.org>
	<20100909205056.1ac7989a@schatten.dmk.lab>
	<4C8A07B3.1050603@kernel.org>
	<20100910162658.254b224a@schatten.dmk.lab>
	<4C8A46D9.5020303@kernel.org>
	<20100913005151.GB411@dastard>
	<4C8DDBEC.3010900@kernel.org>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


one more detail, seems like this never ends... sorry :) 

On Mon, 13 Sep 2010 10:08:12 +0200
Tejun Heo <tj@kernel.org> wrote:




> +
> +For an unbound wq, the above concurrency management doesn't apply and
> +the gcwq for the pseudo unbound CPU tries to start executing all work
> +items as soon as possible.  The responsibility of regulating
> +concurrency level is on the users.  There is also a flag to mark a
> +bound wq to ignore the concurrency management.  Please refer to the
> +Workqueue Attributes section for details.

renamed to "API section" 

regards,
Flo
