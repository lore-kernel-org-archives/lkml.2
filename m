Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab2IMBIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 21:08:20 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45047 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab2IMBIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 21:08:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120912232454.947953753@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
	<20120912232450.500619493@linuxfoundation.org>
	<20120912232454.947953753@linuxfoundation.org>
Date: Wed, 12 Sep 2012 21:08:17 -0400
Message-ID: <CA+5PVA5TuUo329wGe6UGCbrq1o7rOs5uMosNtv-38ZqhrVPUAQ@mail.gmail.com>
Subject: Re: [ 042/108] NFS: Alias the nfs module to nfs4
From: Josh Boyer <jwboyer@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bryan Schumaker <bjschuma@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 7:28 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>
> 3.5-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> commit 425e776d93a7a5070b77d4f458a5bab0f924652c upstream.
>
> This allows distros to remove the line from their modprobe
> configuration.
>
> Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> [bwh: Backported to 3.2: adjust context]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Could someone elaborate why this is acceptable now, while it wasn't
during the timeframe I sent an identical patch months ago?

http://lkml.indiana.edu/hypermail/linux/kernel/1204.3/02064.html

We had some trouble in Fedora 17 because of this and would up with
patches to nfs-utils because the modalias was NAKed.  If we're bringing
it into stable (and upstream) at this point, it would be good to know
what changed so I can go and undo what we did because I was told no.

Please don't get me wrong, I'm all for simplicity.  I'm just perhaps
so simple that the brief changelog confuses me because it doesn't
actually describe why the original solution wasn't followed up on.

josh
