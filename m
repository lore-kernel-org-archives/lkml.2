Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab2HFGfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 02:35:53 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46960 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2HFGfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 02:35:52 -0400
MIME-Version: 1.0
In-Reply-To: <501F296B.4070004@wwwdotorg.org>
References: <20120801152240.GA16388@sig21.net>
	<CACRpkdZryc95WpSXddCrLvZGDsv4x-ndX9XcVzoxaDCT53AFLw@mail.gmail.com>
	<501F296B.4070004@wwwdotorg.org>
Date: Mon, 6 Aug 2012 08:35:51 +0200
Message-ID: <CACRpkdZ8AO5SrjJvJxvpauEadQOKMNaW_Pxxzhjk5hWnVB1b+g@mail.gmail.com>
Subject: Re: DT GPIO numbering?
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Johannes Stezenbach <js@sig21.net>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 4:18 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> I can't comment on the sysfs-vs-dev interface location, but I don't
> think it addresses Johannes' issue; finding out which GPIO IDs are
> provided by which devices.
>
> Perhaps in each device's sysfs node, there should be some information
> re: which GPIO range it provides. Right now, perhaps a text file with
> the GPIO base it it.

Yes that could work ...

> With the new /dev interface you mention above,
> perhaps a symlink to the /dev file, or a file containing the /dev file's
> major/minor number. Or, is there such a thing already (other than
> debugfs's gpio file).

Nothing I know of, but yes the day we come up with something,
it needs to be backward-compatible some way.

The problem is that there is really no reference userspace
like "lsgpio" or so. Maybe the first step could be to create that.

Yours,
Linus Walleij
