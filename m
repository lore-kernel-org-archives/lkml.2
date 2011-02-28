Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab1B1Kbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:31:51 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53069 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1B1Kbu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:31:50 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 28 Feb 2011 16:01:33 +0530
Subject: RE: [PATCH] davinci: cpufreq: fix section mismatch warning
Thread-Topic: [PATCH] davinci: cpufreq: fix section mismatch warning
Thread-Index: AcvSP5GEANME27LETvOA4qWU9+NJ3gE8sBjg
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BF35C9C@dbde02.ent.ti.com>
References: <1298345033.3903.7.camel@mola>
In-Reply-To: <1298345033.3903.7.camel@mola>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, Feb 22, 2011 at 08:53:53, Axel Lin wrote:
> Fix below section mismatch warning:
> WARNING: vmlinux.o(.data+0x673c): Section mismatch in reference from the variable davinci_driver to the function .init.text:davinci_cpu_init()
> The variable davinci_driver references
> the function __init davinci_cpu_init()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Will queue for Kevin to send upstream.

Thanks,
Sekhar

