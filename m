Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab1LVSBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 13:01:51 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55538 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab1LVSBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 13:01:47 -0500
MIME-Version: 1.0
In-Reply-To: <1324570881-11503-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1324570881-11503-1-git-send-email-Kyle.D.Moffett@boeing.com>
Date: Thu, 22 Dec 2011 13:01:45 -0500
Message-ID: <CA+5PVA7ZzDEsLrN_W=fo_GzSwV4Nj7KBT7zJRoVs0b4TcZvwBQ@mail.gmail.com>
Subject: Re: [PATCH] powerpc/currituck: Fix up missing MPIC_PRIMARY flag
From: Josh Boyer <jwboyer@gmail.com>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
Cc: linuxppc-dev@lists.ozlabs.org, Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 11:21 AM, Kyle Moffett
<Kyle.D.Moffett@boeing.com> wrote:
> The 44x/currituck platform didn't get updated when the MPIC code
> inverted the flag from MPIC_PRIMARY => !MPIC_SECONDARY.  Fix it up.
>
> Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>

I already included this fixup in my 4xx tree 'next' branch.  A pull
request was sent to Ben as well.

http://git.infradead.org/users/jwboyer/powerpc-4xx.git/commitdiff/eb975652b8fa0c4f08a52744d34bdebf66589d4b

josh
