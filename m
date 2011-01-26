Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1AZWzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 17:55:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49737 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab1AZWzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 17:55:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=O+wL7M71aWVRpm6GSaHCV+9aaqsxZVX8leI2JLCt4q10nsDNUn9uUtrHyBkGF/kcto
         RRwqgg5cY4yJ5bW0DQI+JKyTavxExz3eXfYMEDpixEMkELvc3l+L4R767paYvHSDwpla
         CxHkzRC3mVmGjRijuwP3WSHH3T/pLC6hApOOY=
MIME-Version: 1.0
In-Reply-To: <20110126195810.247325792@linutronix.de>
References: <20110126195810.247325792@linutronix.de>
Date: Wed, 26 Jan 2011 14:55:36 -0800
Message-ID: <AANLkTimpYHLESkFV8_E+XGimJkh5YQVn=5gyqSpJpg0X@mail.gmail.com>
Subject: Re: [patch 0/6] rwsem: Cleanup duplicate code all over the place
From: Tony Luck <tony.luck@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>, x86@kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Henderson <rth@twiddle.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 12:05 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> The archictecture specific rwsem implementations have a lot of
> duplicated code. The following series cleans that up.

Looks good. Builds on all my ia64 configs. Boots & runs on at least one.

Acked-by: Tony Luck <tony.luck@intel.com>
