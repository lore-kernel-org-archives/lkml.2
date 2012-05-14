Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab2ENV2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:28:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55833 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758055Ab2ENV2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:28:45 -0400
Date: Mon, 14 May 2012 22:28:42 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: Kamal Mostafa <kamal@canonical.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dell-laptop: rfkill blacklist Dell XPS 13z, 15z
Message-ID: <20120514212842.GA9561@srcf.ucam.org>
References: <1337023652-11661-1-git-send-email-kamal@canonical.com>
 <20120514193718.GA6438@srcf.ucam.org>
 <4FB16659.6040704@dell.com>
 <20120514211959.GA9394@srcf.ucam.org>
 <4FB1774D.4080106@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB1774D.4080106@dell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 04:21:17PM -0500, Mario Limonciello wrote:

> The outliers of Inspiron and XPS don't seem to follow the interface as 
> explicitly.  It is not broken on Windows.  I don't have an 
> understanding why it's not, but conjecture that it's a different 
> interface being used on these that I don't have information on yet.

If we're using a different interface to Windows then we're still doing 
it wrong. I'll take patches that port us to the interface that's 
actually being used, but I won't take patches that just try to cover up 
a broken interface that the vendor doesn't test.

> You would be better to only match on Latitude and Vostro and anything 
> else that people want to opt in via a paramater than to remove the 
> interface entirely IMO.

If Windows uses this interface on Latitude and Vostro then I'll do that, 
but otherwise no.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
