Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab2E2HkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 03:40:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49688 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab2E2HkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 03:40:12 -0400
Message-ID: <4FC47D49.50204@zytor.com>
Date: Tue, 29 May 2012 00:39:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, tglx@linutronix.de, mingo@redhat.com,
        sameo@linux.intel.com, x86@kernel.org, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] x86/platform: sta2x11: add platform code
References: <4FC477A1.4010709@zytor.com>  <4FC47003.1080906@zytor.com>  <4FC40C74.8050003@zytor.com>  <20120527205020.GA3050@mail.gnudd.com> <20120529063738.GA22711@mail.gnudd.com> <20120529070557.GA23373@mail.gnudd.com> <20120529073417.GA25041@mail.gnudd.com>
In-Reply-To: <20120529073417.GA25041@mail.gnudd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 12:34 AM, Alessandro Rubini wrote:
> 
> So, it seems I must go device-tree for the chipset-like mounting. And
> what about plug in boards? I may arrange a firmware-loader mechanism
> as an alternative, so the vendor of each board can provide the the
> platform data for all the sub devices. Actually, if firmware loader is
> acceptable, I'd try it first, to avoid changing the boot procedure;
> maybe I can save myself from the device tree.
> 

If you're going to use a binary blob for the loader, use either ACPI 5
SSDT or device tree format.  This is *not* something where (re)invention
is encouraged.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

