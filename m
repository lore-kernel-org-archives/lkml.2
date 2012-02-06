Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab2BFQb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:31:58 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:47166 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab2BFQb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:31:57 -0500
Date: Mon, 6 Feb 2012 16:31:55 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Updated throttling fix patchkit
Message-ID: <20120206163155.GC32061@srcf.ucam.org>
References: <1328545032-21373-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328545032-21373-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 08:17:07AM -0800, Andi Kleen wrote:
> Here's an updated patchkit to fix ACPI thermal zone throttling and some
> related problems. See the individual patches for more details.

ACK to the set (with the provisos noted on a couple of the individual 
patches). It may need some rebasing depending on whether Len merges my 
other patch or not.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
