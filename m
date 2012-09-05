Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958Ab2IEQvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 12:51:50 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45370 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab2IEQvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 12:51:49 -0400
MIME-Version: 1.0
In-Reply-To: <s5hd3222azc.wl%tiwai@suse.de>
References: <s5hd3222azc.wl%tiwai@suse.de>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Wed, 5 Sep 2012 13:51:27 -0300
Message-ID: <CAKi4VAKBDPnYak9j0AwGXcnUnxNMEtUww+cQ8b_RD_Ea+hH5tQ@mail.gmail.com>
Subject: Re: A workaround for request_firmware() stuck in module_init
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@canonical.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 10:06 AM, Takashi Iwai <tiwai@suse.de> wrote:
> Hi,
>
> as I've got recently a few bug reports regarding the stuck with
> request_firmware() in module_init of some sound drivers, I started
> looking at the issue.  Strangely, the problem doesn't happen on
> openSUSE 12.2 although it has the same udev version with libkmod as
> Fedora.  So I installed Fedora 17, and indeed I could see a problem
> there.

I fail to see how this is related to libkmod. It's indeed related to
the fact that udev now timeout a modprobe request so people stop doing
crazy things and like start daemons as modprobe's install rules. And
that's true even with old module-init-tools.



Lucas De Marchi
