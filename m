Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab2AEVCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 16:02:09 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64143 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656Ab2AEVCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 16:02:07 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <CAOesGMj=EVXGNNY+nj4BvsrFShhvQkSeS2RB8SYtVOXOENwFng@mail.gmail.com>
References: <1325610682-24811-1-git-send-email-olof@lixom.net>
	<1325610682-24811-5-git-send-email-olof@lixom.net>
	<1325762519.3635.22.camel@mfleming-mobl1.ger.corp.intel.com>
	<CAOesGMj=EVXGNNY+nj4BvsrFShhvQkSeS2RB8SYtVOXOENwFng@mail.gmail.com>
Date: Thu, 5 Jan 2012 13:02:07 -0800
Message-ID: <CAOesGMhh1bJp2aLD3GtEdJByVnPqbEf2jcHTTH=fJsaxtFG0Pg@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86: efi: add basic error handling
From: Olof Johansson <olof@lixom.net>
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 9:52 AM, Olof Johansson <olof@lixom.net> wrote:

> Not much, since the systems I have won't boot if there's an error
> (even if graceful) and I didn't have a console with earlyprintk
> support until yesterday. I'll beat on it a bit this afternoon but it
> should be OK as it is.

Ok, tested now to the point that I made sure the errors are shown
appropriately on the early console for the appropriate error paths,
but since the system doesn't come up there isn't much more than that
to test at this time.


-olof
