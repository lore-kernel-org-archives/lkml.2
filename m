Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab2AES0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:26:32 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45123 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab2AES0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:26:30 -0500
Date: Thu, 5 Jan 2012 18:26:27 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Len Brown <lenb@kernel.org>, Azael Avalos <coproscefalo@gmail.com>,
        Thomas Renninger <trenn@suse.de>, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] toshiba_acpi: Add blacklist for models with
 hotkey problems
Message-ID: <20120105182627.GE24242@srcf.ucam.org>
References: <1325617358-8286-1-git-send-email-seth.forshee@canonical.com>
 <1325617358-8286-5-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325617358-8286-5-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 01:02:38PM -0600, Seth Forshee wrote:
> Several Satellite models have a buggy implementation of the INFO method
> that causes ACPI exceptions when executed:
> 
>  ACPI Error: Result stack is empty! State=ffff88012d70f800 (20110413/dswstate-98)
>  ACPI Exception: AE_AML_NO_RETURN_VALUE, Missing or null operand (20110413/dsutils-646)
>  ACPI Exception: AE_AML_NO_RETURN_VALUE, While creating Arg 0 (20110413/dsutils-763)
>  ACPI Error: Method parse/execution failed [\_SB_.VALZ.GETE] (Node ffff880131175eb0), AE_AML_NO_RETURN_VALUE (20110413/psparse-536)
>  ACPI Error: Method parse/execution failed [\_SB_.VALZ.INFO] (Node ffff880131175ed8), AE_AML_NO_RETURN_VALUE (20110413/psparse-536)
>  toshiba_acpi: ACPI INFO method execution failed
>  toshiba_acpi: Failed to query hotkey event

Ugh, in several ways. The hotkeys on these machines are presumably 
supposed to work - do we have any idea what we should be doing?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
