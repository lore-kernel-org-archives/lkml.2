Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab1ACN4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:56:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932218Ab1ACN42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:56:28 -0500
Date: Mon, 3 Jan 2011 08:56:02 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, 599368@bugs.debian.org,
        608138@bugs.debian.org, Cesare Leonardi <celeonar@gmail.com>
Subject: Re: [PATCH v2] watchdog: Improve initialisation error message and
 documentation
Message-ID: <20110103135602.GO3743@redhat.com>
References: <1294005610.3167.99.camel@localhost>
 <1294009362.3167.126.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294009362.3167.126.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 02, 2011 at 11:02:42PM +0000, Ben Hutchings wrote:
> The error message 'NMI watchdog failed to create perf event...'  does
> not make it clear that this is a fatal error for the watchdog.  It
> also currently prints the error value as a pointer, rather than
> extracting the error code with PTR_ERR().  Fix that.
> 
> Add a note to the description of the 'nowatchdog' kernel parameter to
> associate it with this message.
> 
> Reported-by: Cesare Leonardi <celeonar@gmail.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Looks good, thanks.  I'll add it to my queue.

Cheers,
Don
