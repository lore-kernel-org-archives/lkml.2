Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab0KNUhf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 15:37:35 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38170 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab0KNUhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 15:37:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QiFE4my/ON6trSfxfzkCPrLrOiXHiP3CQyKdYxohtQH0DPzthoVXJyb2rhu8GMA6A5
         w8MEI0GvoHJFFvJRigchwTqpCfSUjHI5KLC4LoYYS923FwPJ3+O9q17bv3AXrtZC76zf
         Urczo/Ha6Pem5J+JGAIu0VbzuvuuJtfLOGr+Q=
MIME-Version: 1.0
In-Reply-To: <AANLkTimtWoqST8ch9CyB3g-CyvfiynXRDLwmGdLDdiYk@mail.gmail.com>
References: <AANLkTimtWoqST8ch9CyB3g-CyvfiynXRDLwmGdLDdiYk@mail.gmail.com>
Date: Sun, 14 Nov 2010 21:37:33 +0100
Message-ID: <AANLkTi=7TwkZOHDcswXp-SgEzs4Ms12xcQ0+Ga9t21DT@mail.gmail.com>
Subject: Re: [PATCH v3, x86]: Use selfsnoop HW feature to manage conflicting
 memory types
From: Uros Bizjak <ubizjak@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 14, 2010 at 7:33 PM, Uros Bizjak <ubizjak@gmail.com> wrote:
> Hello!
>
> Attached patch enhances v2 patch at [1] to disable selfsnoop with a
> kernel command line parameter. The feature is also disabled on all
> processors earlier than Core 2 due to Pentium-M errata.
>
> I have investigated the erratas in this area and documented the one
> found in the source.
>
> The patch was tested on 4 core i7 (8 threads) and there were no
> problems at all with the patched kernel.

Also, I'd like to point out that similar change was introduced in
FreeBSD as part of r195749 in July 2009, see [1].

[1] http://svn.freebsd.org/viewvc/base?view=revision&revision=195749

Uros.
