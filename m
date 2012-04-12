Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964864Ab2DLCJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 22:09:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60199 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933629Ab2DLCJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 22:09:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAA9xbM6vKjhy9LH4f=dQqAKRxjQ=3DpP2_QFL0=fJdx+y47JZw@mail.gmail.com>
References: <1333479610-13321-1-git-send-email-paul.gortmaker@windriver.com>
	<CAP=VYLroi_uGBUmwEE2g=nH2z-oD6nYwo_D+o+QHMtWERP=yvA@mail.gmail.com>
	<CA+8MBbJ-Ub9JtJ+nbMScOfcP6HtAjmQ0qZkWOa6H_3A3VHwz7g@mail.gmail.com>
	<CAA9xbM6vKjhy9LH4f=dQqAKRxjQ=3DpP2_QFL0=fJdx+y47JZw@mail.gmail.com>
Date: Wed, 11 Apr 2012 19:09:21 -0700
X-Google-Sender-Auth: 4P8H6-5e9d9dG2H4UjTGaR5DgPU
Message-ID: <CA+8MBbKR-iam78WYfPOkmUdSxtFmfzKU9EvSJSr5g46yk0E+2w@mail.gmail.com>
Subject: Re: [PATCH] ia64: populate the cmpxchg header with appropriate code
From: Tony Luck <tony.luck@intel.com>
To: =?ISO-8859-1?Q?=C9meric_Maschino?= <emeric.maschino@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 5:15 PM, Émeric Maschino
<emeric.maschino@gmail.com> wrote:
> Will this improve anything w.r.t.
> https://bugzilla.kernel.org/show_bug.cgi?id=42757

I'd be amazed if it did ,,, these patches are just moving the same code
from one header file to a new one (<asm/cmpxchg.h>) - so I don't expect
to see any functional changes.

-Tony
