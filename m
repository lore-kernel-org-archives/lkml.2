Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab2KKL33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 06:29:29 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:39822 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab2KKL31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 06:29:27 -0500
MIME-Version: 1.0
In-Reply-To: <509E4EB7.6050601@gmail.com>
References: <1352529892-17610-1-git-send-email-stefanha@gmail.com>
	<509E4EB7.6050601@gmail.com>
Date: Sun, 11 Nov 2012 12:29:26 +0100
Message-ID: <CAJSP0QUQYB+-wxCA8DqCp_ziT0+2GeFmchVAdw=xahDXvhDPag@mail.gmail.com>
Subject: Re: [PATCH] ALSA: line6: move staging driver to sound/usb/
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: alsa-devel@alsa-project.org, Markus Grabner <grabner@icg.tugraz.at>,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2012 at 1:55 PM, Daniel Mack <zonque@gmail.com> wrote:
> Hi,
>
> On 10.11.2012 07:44, Stefan Hajnoczi wrote:
>> The line6 driver supports devices from the Line6 PODxt, POD HD,
>> TonePort, and Variax product families.  This USB sound driver has been
>> in staging since 2009 and is ready for wider review and users.
>
> Thanks a lot for working on this! However, just moving over the current
> code does not seem sufficient.
>
> Alone, script/checkpatch.pl gives me
>
>   total: 9234 errors, 158 warnings, 9233 lines checked
>
> including DOS line feeds, broken indentation and other style issues. I
> think at least most of them need to be fixed.

Thanks for the response and sorry I forgot to check this.

Stefan
