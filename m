Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab2AERxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:53:12 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49515 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab2AERxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:53:11 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1325762483.3635.21.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1325610682-24811-1-git-send-email-olof@lixom.net>
	<1325610682-24811-6-git-send-email-olof@lixom.net>
	<1325762483.3635.21.camel@mfleming-mobl1.ger.corp.intel.com>
Date: Thu, 5 Jan 2012 09:53:10 -0800
Message-ID: <CAOesGMioRf5iDYsOELEq_JvaHdpmLnODV5j5PqmHKqKV7bTBtw@mail.gmail.com>
Subject: Re: [PATCH 5/5] x86: efi: allow basic init with mixed 32/64-bit efi/kernel
From: Olof Johansson <olof@lixom.net>
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 3:21 AM, Matt Fleming <matt.fleming@intel.com> wrote:

> This needs resubmitting as you're undoing the changes you've made in
> PATCH 2/5, i.e. stuff like this,

Yes, I completely messed up here, pretty sad. Fixed up in the series
I'll repost shortly.


-Olof
