Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab0I3JFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 05:05:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56282 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754950Ab0I3JFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:05:43 -0400
Date: Thu, 30 Sep 2010 10:30:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Marc - A. Dahlhaus" <mad@wol.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix capi devicenames
Message-ID: <20100930103010.1a6a7785@lxorguk.ukuu.org.uk>
In-Reply-To: <4CA391B3.1030806@wol.de>
References: <4CA391B3.1030806@wol.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 21:21:23 +0200
"Marc - A. Dahlhaus" <mad@wol.de> wrote:

> capi device names should get changed to what userspace expects.

If userspace isn't following the spec (which has been the spec for many
years) then thats not our problem.

> Without this change recent udev versions can't produce working device
> nodes as the capi control device node name "capi" collides with the
> "capi" directory under which userspace expects to get the application
> device nodes. This also fixes the Documentation.

The documentation isn't broken, the documentation *is* the reference.

NAK. Fix udev.


We have a spec for a reason, if some distro didn't follow it then that's
up to them but they can sort out their own udev.

Alan
