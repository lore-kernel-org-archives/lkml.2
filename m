Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab0DFHZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 03:25:46 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:36734 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757280Ab0DFHZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 03:25:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VDTXv2XbvT31O3V/ETRSQEFJ+4qReiF3yzwMbdE8rtf0X/AleYrXOsHU35lL3ouIN9
         5p97pKgwZGI4Zw+4mFOGPfuZ6Xdmg9HYrvmOh7gFVE+3oVAgD+eYw7erVn1RjkDgRDiR
         wEwNtUWw15u8Q0jt7Om3PTA8dGnCd0syFKpZs=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004060308030.21994@localhost.localdomain>
References: <alpine.LFD.2.00.1004060308030.21994@localhost.localdomain>
Date: Tue, 6 Apr 2010 09:25:38 +0200
Message-ID: <h2ub170af451004060025oe838072pada57b715e18c235@mail.gmail.com>
Subject: Re: [GIT pull request] ACPI patches for 2.6.34-rc3
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 6 kwietnia 2010 09:09 użytkownik Len Brown <lenb@kernel.org> napisał:
> commit c8cf3a14a6615e06504664cd50ca90baa5f2ef7d
> Author: Rafael Wysocki <rjw@sisk.pl>
> Date:   Thu Mar 4 00:25:30 2010 +0000
>
>    ACPI / PM: Move ACPI video resume to a PM notifier
>
>    There is a problem with the ACPI video resume routine that it's
>    executed before the GPU that may be accessed by it.  To fix this
>    issue, move the ACPI video resume to a power management notifier,
>    so that it's executed after resuming all devices, including the GPU.
>
>    http://bugzilla.kernel.org/show_bug.cgi?id=15096
>
>    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>    Acked-by: Matthew Garrett <mjg@redhat.com>
>    Tested-by: Rafał Miłecki <zajec5@gmail.com>
>    Signed-off-by: Len Brown <len.brown@intel.com>

Could you push this one to stable as well, please? It partially fixes
regression reported in:
https://bugzilla.kernel.org/show_bug.cgi?id=15096

This should go to .32 and .33.

-- 
Rafał
