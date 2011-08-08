Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1HHTnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 15:43:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58172 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1HHTnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 15:43:01 -0400
Date: Mon, 8 Aug 2011 21:43:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/11] DIO: Separate fields only used in the submission path from struct dio
Message-ID: <20110808194300.GN5782@one.firstfloor.org>
References: <1312259893-4548-1-git-send-email-andi@firstfloor.org> <1312259893-4548-2-git-send-email-andi@firstfloor.org> <x497h6niy37.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x497h6niy37.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The pages array is only used on submission.  Why did it land in the
> struct dio? 

It's too large for the stack.

-Andi
