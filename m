Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab0HYWXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 18:23:10 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47479 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab0HYWXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 18:23:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UGQvzgdo49DF8jqnGCdpTec79fOjCQRuozVzc6FAFjqMSMin+HCIH+5hdfh4O3IvQP
         UPInmIka8Ci4dvpPEH2Of+DB3rq4B/1B0rFzVeaggwXrnmEFKkSs6Dj7+j4GSQvJRGl7
         FjzWs0s0zWfxgVhaVoj/NiUyY2Pjcf/ScBicU=
MIME-Version: 1.0
In-Reply-To: <20100825144954.233b6d3c.akpm@linux-foundation.org>
References: <14414B36FFA0F1418CB707361EAA199A0194F7D2@CNBEEXC006.nsn-intra.net>
	<20100806124456.GA9107@redhat.com>
	<20100825144954.233b6d3c.akpm@linux-foundation.org>
Date: Wed, 25 Aug 2010 15:23:07 -0700
Message-ID: <AANLkTimHd3xLE0avkmoaeYngYQ7Ueob9r-DUEXm4-rbW@mail.gmail.com>
Subject: Re: [PATCH]exit.c: support larger exit code
From: Tony Luck <tony.luck@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Zhang, Wei-Jovi (NSN - CN/Hangzhou)" <wei-jovi.zhang@nsn.com>,
        mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 2:49 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> There are back-compatibility issues.

Also standards conformance issues. Posix says this about exit():

"The value of status may be 0, EXIT_SUCCESS, EXIT_FAILURE, [CX]   or
any other value, though only the least significant 8 bits (that is,
status & 0377) shall be available to a waiting parent process."

Full reference here:
http://www.opengroup.org/onlinepubs/000095399/functions/exit.html

-Tony
