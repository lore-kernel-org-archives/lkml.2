Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706Ab0JHVKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 17:10:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60613 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759368Ab0JHVKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 17:10:31 -0400
Date: Fri, 8 Oct 2010 14:10:43 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jeffrey Carlyle <jeff.carlyle@motorola.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Lun Chang <L.chang@motorola.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regulator: avoid deadlock when disabling regulator
 with supply
Message-ID: <20101008211042.GC6098@opensource.wolfsonmicro.com>
References: <20101008185739.GA6098@opensource.wolfsonmicro.com>
 <1286567360-11337-1-git-send-email-jeff.carlyle@motorola.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286567360-11337-1-git-send-email-jeff.carlyle@motorola.com>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 02:49:19PM -0500, Jeffrey Carlyle wrote:
> I have a regulator A that sets regulator B as its supply. When I call
> set_supply to add B as the supply for A, regulator A gets added to the
> supply_list for regulator B.
> 
> When I call regulator_disable(A), I end up with a call chain like this:

Looks good!

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
