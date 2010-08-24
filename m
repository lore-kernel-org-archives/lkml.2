Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab0HXUUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 16:20:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755390Ab0HXUUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 16:20:16 -0400
MIME-Version: 1.0
In-Reply-To: <4c7413025613b269c@agluck-desktop.sc.intel.com>
References: <4c7413025613b269c@agluck-desktop.sc.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Aug 2010 13:19:51 -0700
Message-ID: <AANLkTinMbTu6H9m70sapfpGHC4secUsaUqZKkg_=CWA6@mail.gmail.com>
Subject: Re: [PATCH v2] guard page for stacks that grow upwards
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-ia64@vger.kernel.org,
        John David Anglin <dave.anglin@nrc-cnrc.gc.ca>,
        Kyle McMartin <kyle@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 11:44 AM, Luck, Tony <tony.luck@intel.com> wrote:
>
> Built, booted & tested on ia64
> Built for x86_64 (but not booted or tested)
> pa-risc - untested

Ok, applied. I do think we could do the "VM_GROWSDOWN = 0" trick for
PA-RISC  (so that the code for the growsdown case would be compiled
away there), but that definitely needs somebody who actually cares
specifically about PA-RISC.

Adding the people who have signed off on parisc-specific patches in
recent memory to the cc. Maybe somebody could be convinced to care.

                         Linus
