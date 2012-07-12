Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161537Ab2GLSPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 14:15:30 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60192 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab2GLSP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 14:15:29 -0400
Date: Thu, 12 Jul 2012 19:19:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Richard Fontana <fontana2012@gmail.com>, "Bradley M. Kuhn" <bkuhn@ebb.org>,
        tytso@mit.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/6] copyleft-next: remove section 7 -
 anti-tivoization
Message-ID: <20120712191903.3fba11aa@pyramind.ukuu.org.uk>
In-Reply-To: <1342115325-9443-6-git-send-email-mcgrof@do-not-panic.com>
References: <1342115325-9443-1-git-send-email-mcgrof@do-not-panic.com>
	<1342115325-9443-6-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012 10:48:44 -0700
"Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:

> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> 
> The anti-tivoization clauses must go if we want this license
> to be ever considered for usage with the Linux kernel.
> This patch removes that entire section.

The kernel license won't be changing anyway. It's too big a task to
figure out. Plus if you want to change license and the new license
doesn't contain protection against DRM abusers then I for one will be
withholding my permission to change it until one is added, because the
existing GPLv2 protection while unclear is there and remains to be
litigated.

Given there are people who hold the reverse true your lock detector
should have spewed ...


There are much more important things a GPL-next needs because of its use
beyond software - protection against "design right" and "design patent"
abuses. Without that the current habit of using the GPL for 3D print
designs is potentially going to end in tears.

The way to allow DRM abuse is to have a "lesser" license which allows
abuse, just as with lesser licenses for linking.

Alan
