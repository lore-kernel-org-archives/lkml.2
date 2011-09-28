Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab1I1IAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:00:38 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:53380 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1I1IAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:00:37 -0400
Subject: Re: [PATCH v5]: Improve performance of LZO hibernation
From: Bojan Smojver <bojan@rexursive.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Wed, 28 Sep 2011 18:00:36 +1000
In-Reply-To: <CAOJsxLFGpU53AQRw-nKsz_Lz_QMDP+RDUD5J3bYzbAA_+ngaAA@mail.gmail.com>
References: <1317183650.2067.10.camel@shrek.rexursive.com>
	 <CAOJsxLGam5htmwtTZOuPka02+CZ1Fkv1b+SuYMJ8x9VRntFzRQ@mail.gmail.com>
	 <1317194947.1998.18.camel@shrek.rexursive.com>
	 <CAOJsxLFGpU53AQRw-nKsz_Lz_QMDP+RDUD5J3bYzbAA_+ngaAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317196836.1998.29.camel@shrek.rexursive.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 10:48 +0300, Pekka Enberg wrote:
> Yes, the threads are stopped. What happens after that? Will the
> hibernation process be aborted? How can this be tested?

Oh, I didn't answer the other possibility - that we stopped the threads
form hibernation code. This is what we want. Compression/decompression
threads stop on our request (i.e. not an error). We continue with the
process, because there is no more data to compress/decompress.

-- 
Bojan

