Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab0HSVcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 17:32:55 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46287 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab0HSVcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 17:32:53 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTiny_N-UqzuVaftLj75e_b0PjsdHstH8ZKx5mw7O@mail.gmail.com>
References: <20100801074831.1099.3318.stgit@angua> <AANLkTiny_N-UqzuVaftLj75e_b0PjsdHstH8ZKx5mw7O@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 19 Aug 2010 15:32:32 -0600
X-Google-Sender-Auth: Cu5Ice9QrQkXcsf3JiK8Ox41VoM
Message-ID: <AANLkTi=12oe7hquDJ4NN_S=cFdfndfxxkOmzqPziD2CE@mail.gmail.com>
Subject: Re: [PATCH] of/device: Replace struct of_device with struct of_platform
To: Timur Tabi <timur@freescale.com>
Cc: sfr@canb.auug.org.au, monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
        sparclinux@vger.kernel.org, davem@davemloft.net,
        alsa-devel mailing list <alsa-devel@alsa-project.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 2:36 PM, Timur Tabi <timur@freescale.com> wrote:
> On Sun, Aug 1, 2010 at 2:57 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>
>>  sound/soc/fsl/mpc8610_hpcd.c                  |    4 +-
>
> This file is/was significantly rewritten for 2.6.37.  I posted a fix
> to the alsa mailing list, but it will conflict with your patch.  You
> might want to remove all changes to sound/soc/fsl from this commit.

This change is already in Linus' tree.

g.
