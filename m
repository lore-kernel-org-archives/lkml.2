Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab0L0Osa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 09:48:30 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44783 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab0L0Os1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 09:48:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=Pi9V/BUveoJeJPGk3iNvNq0prfP0Pkx4QsJbbqJPP+ZMgBRFcQBENfXqEqU2Urtf9T
         fwa3pl7mB9ARdERoVVWfhVlUErvHvSpMqs/N7SGZJWIfO1IKX3dZkHCuOljfflnOQoNk
         6VG3DJfbyBLTLfswTqTFlX2rJlR0OvSlnBTbI=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <4D18A480.2060309@example.com>
References: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
	<4D18A480.2060309@example.com>
Date: Mon, 27 Dec 2010 15:48:27 +0100
Message-ID: <AANLkTi=WhSP1ceHBW95n1e-gHwwnt36h3czFGuKsEny6@mail.gmail.com>
Subject: Re: linux-next: Tree for December 27
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: piotr@hosowicz.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/27 Piotr Hosowicz <piotr@hosowicz.com>:
> On 27.12.2010 07:04, Stephen Rothwell wrote:
>
> Hello,
>
> I noticed that after first reboot with this kernel that my MP3 collection in
> mocp layed on Ext4 fs opens painfully slow. It is not my mistake, because I
> always do it the same way, new kernel, then music on. The problem is not
> present in rc7-git4. I could measure it in some way (timing ls -la in tht
> dir?) if somebody needs it.
>
> Regards,
>
> Piotr Hosowicz
>

You tried mblk_io_submit mount-option for that partition?

- Sedat -
