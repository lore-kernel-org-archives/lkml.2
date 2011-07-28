Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab1G1XuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:50:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47666 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab1G1XuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:50:05 -0400
Date: Fri, 29 Jul 2011 01:50:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "herton.krzesinski@canonical.com" <herton.krzesinski@canonical.com>,
        "gengor@gentoo.org" <gengor@gentoo.org>,
        "Fry, Donald H" <donald.h.fry@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "tim.bird@am.sony.com" <tim.bird@am.sony.com>
Subject: Re: [PATCH] [64/99] Revert "iwlagn: Support new 5000 microcode."
Message-ID: <20110728235002.GK8006@one.firstfloor.org>
References: <20110727247.325703029@firstfloor.org> <20110727214903.75C262403FF@tassilo.jf.intel.com> <20110728082425.GA2207@redhat.com> <1311860733.5579.152.camel@wwguy-huron>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311860733.5579.152.camel@wwguy-huron>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> just like Gruszka mention, please include 
> commit dd7a2509b3a79b290730a9c6a784bf03fedabb9a

That patch is already included.

Ok I dropped the revert for now. Let's see what happens.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
