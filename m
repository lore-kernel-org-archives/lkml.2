Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab2BGAC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:02:59 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58226 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754155Ab2BGAC6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:02:58 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1328563908.git.vjaquez@igalia.com>
References: <cover.1328563908.git.vjaquez@igalia.com>
Date: Tue, 7 Feb 2012 02:02:56 +0200
Message-ID: <CAMP44s3a7C1JTvrFd8FQxthJYRa4EDEi9sw8Oz=wKcJ_Pfu6dg@mail.gmail.com>
Subject: Re: [PATCH 0/4] staging: tidspbridge: remove desgin-by-contract macros
From: Felipe Contreras <felipe.contreras@gmail.com>
To: =?UTF-8?Q?V=C3=ADctor_Manuel_J=C3=A1quez_Leal?= 
	<vjaquez@igalia.com>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/7 Víctor Manuel Jáquez Leal <vjaquez@igalia.com>:
> These patches removes all the design-by-contract (DBC) macros in the
> tidspbridge.
>
> Also it removes the config option CONFIG_TIDSPBRIDGE_DEBUG.
>
> The patches are applied above these submitted patches:
> http://thread.gmane.org/gmane.linux.kernel/1246081
>
> The main reasons to remove these DBC macros are
>
> * The kernel in general doesn't follow the DBC approach
>
> * They only provide a needless verbosity, since they are available only
>  when CONFIG_TIDSPBRIDGE_DEBUG is enabled. If they were useful they
>  should be left for the dynamic debugging always. So, if they are not
>  used, is dead code at the end, and should be removed.
>
> * Deleting them means less code to maintain
>
> As the Emperor Joseph II told to Mozart in the motion picture Amadeus:
> "It's quality work. And there are simply too many notes, that's
> all. Just cut a few and it will be perfect."

The whole series is fine by me :)

Even the warnings that don't depend on DEBUG have been neglected
anyway =/ Will send some patches for a few of them soon.

Cheers.

-- 
Felipe Contreras
