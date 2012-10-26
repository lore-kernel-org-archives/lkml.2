Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab2JZMtK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:49:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45066 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932708Ab2JZMtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:49:08 -0400
MIME-Version: 1.0
In-Reply-To: <5089902E.9020204@deserettechnology.com>
References: <5087B517.9090703@deserettechnology.com>
	<CAJdJm_NrmfU17aQDmO0hbihV673Of0iFnLqk4=-sPh=g44eixA@mail.gmail.com>
	<5089902E.9020204@deserettechnology.com>
Date: Fri, 26 Oct 2012 08:49:06 -0400
Message-ID: <CAJdJm_PS-MRXmiuvEtFv30P73hs=ZTgwX9FdYah-7KFHDmQLEw@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Add support for BCM20702A0 [0b05, 17b5]
From: Anderson Lizardo <anderson.lizardo@openbossa.org>
To: jeff@deserettechnology.com
Cc: gustavo@padovan.org, marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

On Thu, Oct 25, 2012 at 3:17 PM, Jeff Cook <jeff@deserettechnology.com> wrote:
> Thanks for the help everyone. I did skim SubmittingPatches prior to
> submission, but dropped off before sections 12 and 15; the information
> seemed outdated since it made no mention of git by the time I stopped
> reading (around section 9 or so), so I looked elsewhere.
>
> I will resubmit according to the information in Section 15. Do I need to
> add something like "try 2" to the patch's subject line, or is it okay
> without that?

Usually I generate a new patch with "git format-patch HEAD^" and edit
the "[PATCH]" prefix to become "[PATCH v2]" and resend the patch
using:

git send-email --to linux-bluetooth@...  --in-reply-to AAA
0001-name-of-the-patch.patch

where "AAA" is the "Message-ID" of the original patch (as seen in the
mail headers, e.g. 5087B517.9090703@deserettechnology.com for your
original patch). and "0001-name-of-the-patch.patch" is the filename
for the patch created by git format-patch.

Hope that helps,
-- 
Anderson Lizardo
Instituto Nokia de Tecnologia - INdT
Manaus - Brazil
