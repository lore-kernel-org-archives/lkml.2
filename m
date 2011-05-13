Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759649Ab1EMQzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:55:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36164 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759618Ab1EMQzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B5QMv0FaofYZGERf+UYwZYByaTGf5+aiFI8ghrfdeiWZ9hVWpQLTCTMNmFJwEAgoEf
         2IFlrhDe/Zx0bpa6kOmLUuWmDwxaCKRZX4chUcqsdGY98JnxZG3Y9Hw4dlsZdlD//Qwj
         L8R0B9u2EavjFHcG0O0s9DJXK07p7aPnfjREc=
MIME-Version: 1.0
In-Reply-To: <20110513155605.GA30674@linux-mips.org>
References: <7aa38c32b7748a95e814e5bb0583f967@localhost>
	<20110513150707.GA26389@linux-mips.org>
	<BANLkTikcyEzjOWt9pWToE=89dySSEYbw_g@mail.gmail.com>
	<20110513155605.GA30674@linux-mips.org>
Date: Fri, 13 May 2011 09:55:21 -0700
Message-ID: <BANLkTinnALQV6dXkJ0AjaQ1=bTawYMMkuQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] MIPS: Replace _PAGE_READ with _PAGE_NO_READ
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>,
        Jayachandran C <jayachandranc@netlogicmicro.com>
Cc: David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 8:56 AM, Ralf Baechle <ralf@linux-mips.org> wrote:
> I'm not totally certain with my explanation but it seemed like a good
> working hypothesis.  Jayachandran C. bisected this morning's linux-queue
> on his Netlogic XLR which is MIPS64 R1 and found this comment causing
> the problem.

Jayachandran, could you please confirm/deny the following:

Netlogic XLR is a MIPS64 R1 system.

You are running a 32-bit kernel.

You are using 64-bit physical addresses.

You are not enabling RI/XI.

The commit that caused the regression was "[PATCH 1/4] MIPS: Replace
_PAGE_READ with _PAGE_NO_READ" (not 2/4, 3/4, or 4/4).

Do you have a log showing the failure, or any other details of what happened?

Thanks.
