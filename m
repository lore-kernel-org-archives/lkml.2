Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946019Ab2K2AZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:25:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54344 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946005Ab2K2AZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:25:32 -0500
Date: Thu, 29 Nov 2012 00:25:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Kent Yoder <key@linux.vnet.ibm.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char/tpm: Use true and false for bools
Message-ID: <20121129002519.GG4939@ZenIV.linux.org.uk>
References: <1354148437-6446-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354148437-6446-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 01:20:37AM +0100, Peter Huewe wrote:

> -		itpm = (probe == 0) ? 0 : 1;
> +		itpm = (probe == 0) ? false : true;

Charming.  Not that original had been better, but...
