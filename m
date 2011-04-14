Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab1DNJkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 05:40:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59015 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab1DNJka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 05:40:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=mime-version:x-originating-ip:in-reply-to:references:date
         :message-id:subject:from:to:cc:content-type;
        b=W09xW0RTqNKzZNVy7L5AKfjVyZ5DazvRt0AOeMMX1C2528V1ds2Da7+Dhp6sHm5aKe
         3KJwuVHpyv/lG8ztyA/dBWBtXAT8gl9h1UxmYGS3fKDQsEmrdDADofxxyr+oqkmQswo6
         wgy6zKwgkA+V5evTwD3bdpMNhEVugPXNR08K4=
MIME-Version: 1.0
X-Originating-IP: [88.209.222.127]
In-Reply-To: <BANLkTinff1NQ-iYevjccO7ADB9h4RH+mOQ@mail.gmail.com>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
	<4DA4B6A8.7030804@gmail.com>
	<BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
	<4DA5DCB8.3040101@gmail.com>
	<BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com>
	<4DA5F569.9020309@gmail.com>
	<BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com>
	<1302756608.2854.10.camel@perseus.themaw.net>
	<BANLkTinff1NQ-iYevjccO7ADB9h4RH+mOQ@mail.gmail.com>
Date: Thu, 14 Apr 2011 11:40:28 +0200
Message-ID: <BANLkTimD9WB_RP1j8yJR7GUn_NuDuM2SHw@mail.gmail.com>
Subject: Re: Unionmount status?
From: Miklos Szeredi <miklos@szeredi.hu>
To: Michal Suchanek <hramrach@centrum.cz>
Cc: Ian Kent <ikent@redhat.com>, Ric Wheeler <ricwheeler@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 11:32 AM, Michal Suchanek <hramrach@centrum.cz> wrote:
> I guess overlayfs includes the better part of unionmount and achieves
> similar level of functionality in much smaller code size and is
> actively developed.
>
> This might make it the best candidate for inclusion so far.
>
> It does not (yet?) support NFS which is one of the options commonly
> used with union solutions, though.

NFS is supported as a lower (read-only) layer, but not as an upper
(read-write) layer.

Thanks,
Miklos
