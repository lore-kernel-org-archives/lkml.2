Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab0LTQOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:14:33 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:54388 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932627Ab0LTQOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:14:32 -0500
Date: Mon, 20 Dec 2010 16:14:20 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ike Panhc <ike.pan@canonical.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Corentin Chary <corentin.chary@gmail.com>
Subject: Re: [PATCH v3 0/6] ideapad: hotkey enablement
Message-ID: <20101220161420.GD25502@srcf.ucam.org>
References: <1292234384-2599-1-git-send-email-ike.pan@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292234384-2599-1-git-send-email-ike.pan@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 05:59:44PM +0800, Ike Panhc wrote:
> Here are the enablement patches for hotkey events on ideapads and these patches
> are made against current checkout of mainline kernel.
> 
> After last time posting on LKML, there are several feedback and these patches
> are modified.

Thanks, merged in -next.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
