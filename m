Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab0LFHuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 02:50:03 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45956 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab0LFHuB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 02:50:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mSTWs9tJtyBblinlAbVKT9XuKZZb27iQ4S0k6QAkPgv3VhZmCMuxG5821WSw02hS1V
         bxsG1l4+kXcimnDqklK4GtWg/3jQiIc29n2Mi2Ckhx9jvSCPMwuE1JCOPtl3G3lhi9tB
         yZqf5bZMcphLdI26pL0lkpQhG3ebWUjQNB+jk=
MIME-Version: 1.0
In-Reply-To: <20101204131638.GA2933@rivierenland.xs4all.nl>
References: <20101204131638.GA2933@rivierenland.xs4all.nl>
Date: Mon, 6 Dec 2010 02:49:59 -0500
Message-ID: <AANLkTi=4zRokvDniW6pPuYgUK5ZCWZo9SOVq8Nn3Gxsu@mail.gmail.com>
Subject: Re: 2.6.37-rc4: kdm crashes consistently, 2.6.36 not affected,
 drm:radeon_cs_ioctl Invalid command stream
From: Alex Deucher <alexdeucher@gmail.com>
To: jurriaan <thunder7@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 4, 2010 at 8:16 AM, jurriaan <thunder7@xs4all.nl> wrote:
> on my up-to-date Debian Unstable system, running on an Phenom X4, on
> an ATI RS880/SB700/built-in Radeon HD 4200 system, kdm crashes
> consistently when trying to start X.org when running kernel 2.6.37-rc4.
> It doesn't when running 2.6.36.
>
> When kdm restarts, I see the following in dmesg:
> [   81.501771] [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !
> [   81.849169] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
>

Should already be fixed with this commit:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a235e4c9302509ac5956bbbffa22eb5ed9fcdc54

Alex
