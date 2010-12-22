Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab0LVUwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 15:52:32 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43251 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab0LVUwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 15:52:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=sC/6Ycr5jyfpAJNeeWScpViDEo5J2GbEjN++1wk83SRJfsSP+Lk4R7CiWRxfEBIBns
         YkucQktlSg7mVjm2uvTR+bfqbEXJIqN8R42nDB8iJia5tdsvInPu+ALpJyQpXssy9z+1
         mfWrr5sJ7bk6l/rFv1aRq8GLNlT+KNi0wl/1s=
MIME-Version: 1.0
In-Reply-To: <20101220141553.GA6088@bitwizard.nl>
References: <20101220141553.GA6088@bitwizard.nl>
From: David Rees <drees76@gmail.com>
Date: Wed, 22 Dec 2010 12:52:08 -0800
Message-ID: <AANLkTikC0gDixPMaj3zZJ9ew7wYx81Ern60omnig-S7c@mail.gmail.com>
Subject: Re: Slow disks.
To: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 6:15 AM, Rogier Wolff <R.E.Wolff@bitwizard.nl> wrote:
> A friend of mine has a server in a datacenter somewhere. His machine
> is not working properly: most of his disks take 10-100 times longer
> to process each IO request than normal.

I've seen noticeable slowdowns before when the disks were running long
SMART tests.  It doesn't seem to affect all drives the same.  The
smartctl data you posted didn't say whether or not the disks were
currently running a SMART test, but it's worth double checking.

-Dave
