Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab1IVLz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 07:55:58 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57728 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753175Ab1IVLzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 07:55:39 -0400
Subject: Re: [PATCH v3 10/10] x86, efi: EFI boot stub support
From: Matt Fleming <matt@console-pimps.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mike Waychison <mikew@google.com>, Matthew Garrett <mjg@redhat.com>
In-Reply-To: <4E7B1F46.9020706@gmail.com>
References: <1315838094-2307-11-git-send-email-matt@console-pimps.org>
	 <1316607036-9235-1-git-send-email-matt@console-pimps.org>
	 <4E7B1F46.9020706@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 12:55:33 +0100
Message-ID: <1316692533.5262.19.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 13:43 +0200, Maarten Lankhorst wrote:

> Even if load_options_size is not always completely reliable, could you
> at least prevent reading more than image->load_options_size? Code
> below doesn't seem to do that currently..

Yeah, that's a very good point.

-- 
Matt Fleming, Intel Open Source Technology Center

