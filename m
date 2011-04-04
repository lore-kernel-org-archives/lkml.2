Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab1DDUvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 16:51:37 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47157 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab1DDUve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 16:51:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=AbmFd65ByIQoS63I93Ftw4vNU7j7BYXExm4G6CYjeulxG9LZDYI7hxo7Z9Ms3clwsO
         Eu0qymt329BA5Wwgijf2lEW6OL47h+S9xEUZbs0NudTDaevv5vpxqw7Pr6nmNXshtNR/
         pM9LS6RSpQqKB3mlFcYuv2Wzmp+i4Np2rsok4=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <664bf5e5585f3d959d6c57524d09353dd8d49f3f.1301936559.git.joe@perches.com>
References: <20110404130036.GB16669@srcf.ucam.org>
	<664bf5e5585f3d959d6c57524d09353dd8d49f3f.1301936559.git.joe@perches.com>
Date: Mon, 4 Apr 2011 22:51:33 +0200
Message-ID: <BANLkTimqTkZgZJf-o04EEkWtdn5-ikKo9A@mail.gmail.com>
Subject: Re: [PATCH 1/2] thinkpad_acpi: Correct !CONFIG_THINKPAD_ACPI_VIDEO warning
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Joe Perches <joe@perches.com>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <mjg@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 4, 2011 at 7:06 PM, Joe Perches <joe@perches.com> wrote:
> Move TPACPI_HANDLE declaration into #ifdef block
> and neaten it a bit.
>
> Signed-off-by: Joe Perches <joe@perches.com>

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
