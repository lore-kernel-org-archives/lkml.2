Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494Ab0FQIII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:08:08 -0400
Received: from mail-yw0-f186.google.com ([209.85.211.186]:44567 "EHLO
	mail-yw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab0FQIIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:08:05 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jun 2010 04:08:05 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HuGALubMFLUEkXOSr53HJbL16gX/t8DUXlIkZoTfmEhA6FwEwhPwTQEAAfJznc/jB/
         fR0zMiIxKVy2RvJPb0KdYGwSEBaCv+szRw2t+oeVbz+cfjA0YejJ218hlhCHE/PLbdSQ
         m+qhhlASLt3cZnP6iLDQx4xLc6MAwp5p5jgYQ=
MIME-Version: 1.0
In-Reply-To: <1276627208-17242-18-git-send-email-vaurora@redhat.com>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
	<1276627208-17242-18-git-send-email-vaurora@redhat.com>
Date: Thu, 17 Jun 2010 10:01:30 +0200
Message-ID: <AANLkTilNAGzn3ZC5eN2ZQMqNhcSWnT-mi_y2TkIkdeUU@mail.gmail.com>
Subject: Re: [PATCH 17/38] union-mount: Union mounts documentation
From: Alex Riesen <raa.lkml@gmail.com>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 20:39, Valerie Aurora <vaurora@redhat.com> wrote:
> +git://git.kernel.org/pub/scm/fs/ext2/val/e2fsprogs.git
> +
> +Currently, whiteout directory entries are not returned to userland.
> +While the directory type for whiteouts, DT_WHT, has been defined for
> +many years, very little userland code handles them.  Userland will
> +never see fallthru directory entries.

This may be a dumb question (I must admit I did only very little research),
but how does one cleanup the topmost layer of whiteouts and fallthroughs,
so that the entries of lower layer(s) can be made visible again?
