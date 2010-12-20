Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839Ab0LTQa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:30:56 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45129 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932586Ab0LTQay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:30:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=OSqbnMrErC3cXsMopd5tyBEjaaCsWPejR8XOcWU05Vx0x2lWMo7RKaGZmNAmzOSFT5
         6aRqwg8oy1ppxCKJCFKIC7m6wv7gZe3R0G/zOmjwSohoKZQAX2vxXUJ64Ag2kPTqjvuy
         /Qe5oxwl95K9rGYm5ATrF3A7E76SLXVlOiQ4c=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101220161817.GE25502@srcf.ucam.org>
References: <AANLkTinbinQjvXo58hKDY4ZaMe1ZrGqWDbhoxdS+JLOG@mail.gmail.com>
	<20101220161817.GE25502@srcf.ucam.org>
Date: Mon, 20 Dec 2010 17:30:52 +0100
Message-ID: <AANLkTikRq9MDLKNNyKKw+qRUJzfANWh2ZshVw8U0wtfc@mail.gmail.com>
Subject: Re: [PATCH] platform/x86: Kconfig: Replace select by depends on ACPI_WMI
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 5:18 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> Applied, thanks. It's easier to handle these if you include the patch in
> the email body, rather than as an attachment.
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
>

[ CC linux-next ]

Thanks :-)!
I mostly use web-based Email, but it's time to setup and use
git-send-email [1] on the working machine.

- Sedat -

[1] http://www.kernel.org/pub/software/scm/git/docs/git-send-email.html
