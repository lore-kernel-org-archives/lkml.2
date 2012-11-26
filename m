Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab2KZLsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:48:39 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40250 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab2KZLsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:48:38 -0500
Date: Mon, 26 Nov 2012 11:53:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: torvalds@linux-foundation.org, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to
 fallocate UAPI
Message-ID: <20121126115345.19977e46@pyramind.ukuu.org.uk>
In-Reply-To: <20121126025520.GC22858@thunk.org>
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
	<20121126002814.GM32450@dastard>
	<20121126025520.GC22858@thunk.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's not like there is any shortage of flag bits, so what's the harm
> of reserving the bit?

Why not just reserve a small group of bits for fs private use in that
case - for any fs.

Alan
