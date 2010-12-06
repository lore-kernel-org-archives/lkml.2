Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0LFWCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:02:47 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34674 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab0LFWCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:02:46 -0500
Date: Mon, 6 Dec 2010 22:02:31 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        carlos@strangeworlds.co.uk, stable@kernel.org, ceolin@ulevel.com
Subject: Re: [PATCH] wmi: use memcmp instead of strncmp to compare GUIDs
Message-ID: <20101206220231.GB1139@srcf.ucam.org>
References: <1290980810-5903-1-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290980810-5903-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied to -next, thanks.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
