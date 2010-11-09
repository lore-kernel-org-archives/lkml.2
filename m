Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab0KIBqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 20:46:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41135 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab0KIBqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 20:46:01 -0500
Date: Tue, 9 Nov 2010 02:46:00 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: [PATCH] iwl3945: Fix oops at module load
Message-ID: <20101109014559.GA21551@basil.fritz.box>
References: <1289253271-19981-1-git-send-email-andi@firstfloor.org>
 <1289254122.12056.86.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289254122.12056.86.camel@wwguy-huron>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I believe the fix already in
> http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=summary
> commit#6e0922e0781884ff4eb3638f10a91b63b6120207

Thanks. Can that please be sent to Linus ASAP? It doesn't really
help my laptop if it's in some obscure git tree.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
