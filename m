Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab2FRUXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 16:23:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45800 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab2FRUXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 16:23:04 -0400
Message-ID: <4FDF8E20.5050606@zytor.com>
Date: Mon, 18 Jun 2012 13:22:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Marko Kohtala <marko.kohtala@gmail.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efivars: prevent Oops if efi_enabled but no EFI runtime
References: <1339706851-10618-1-git-send-email-marko.kohtala@gmail.com> <CAOesGMi2nAecB4Lgti-JSrNTuV4MRA9GEQV1T=BrDxJ-QCq+cQ@mail.gmail.com>
In-Reply-To: <CAOesGMi2nAecB4Lgti-JSrNTuV4MRA9GEQV1T=BrDxJ-QCq+cQ@mail.gmail.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2012 04:00 PM, Olof Johansson wrote:
> 
> I think it would make more sense to return -ENODEV when the function
> pointers aren't set, that way the exit function won't ever be called
> either, so no need to add the checks there.
> 

-ENIXO?  ENODEV is usually some form of "wrong type of device"; ENXIO is
"device is not there."

	-hpa

