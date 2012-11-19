Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab2KSI3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 03:29:44 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:52678 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753146Ab2KSI3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 03:29:43 -0500
Message-ID: <1353313779.2977.106.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] x86: remove dummy long from EFI stub
From: Matt Fleming <matt@console-pimps.org>
To: "Justen, Jordan L" <jordan.l.justen@intel.com>
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "Rosenbaum, Lee G" <lee.g.rosenbaum@intel.com>
Date: Mon, 19 Nov 2012 08:29:39 +0000
In-Reply-To: <1353095127.25102.22.camel@jljusten-ivy>
References: <1351377255-21092-2-git-send-email-cesarb@cesarb.net>
	 <1353095127.25102.22.camel@jljusten-ivy>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 11:45 -0800, Justen, Jordan L wrote:
> Reviewed-by: Jordan Justen <jordan.l.justen@intel.com>
> 
> Lee also tested with Secure Boot. (Thanks Lee)

Thanks guys. I've applied this patch.

-- 
Matt Fleming, Intel Open Source Technology Center

