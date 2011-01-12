Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab1ALEhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 23:37:37 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60363 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab1ALEhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 23:37:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=N7UXHrj0D+SZG8flhJp3seFWc86kcfGUdgaU5San8xYJldsyvW2s/Gx8KY3h8vknCt
         uMBN9rCj/HSwW7fEpW3WRVHZWPB9r6sRof4NQGe39WpNmoXFih/qpXChdrOV5FSrOf+T
         w16x6LCQgeowvEWQqxXMM3MdMScrvMhW6Kmj0=
MIME-Version: 1.0
In-Reply-To: <E1Pcd7R-0007XC-VO@pomaz-ex.szeredi.hu>
References: <E1Pcd7R-0007XC-VO@pomaz-ex.szeredi.hu>
Date: Wed, 12 Jan 2011 15:37:32 +1100
Message-ID: <AANLkTik-=LqSHQ=7zDznx9oCJFViPpp406Yz7J5Z-quj@mail.gmail.com>
Subject: Re: [PATCH] fuse: make fuse_permission() RCU aware
From: Nick Piggin <npiggin@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 11:14 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> Only bail out of fuse_permission() on IPERM_FLAG_RCU when it is
> actually necessary.

Great, thanks for taking a look... How about d_revalidate?
