Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1D0C6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 22:58:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43120 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab1D0C6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 22:58:32 -0400
Date: Wed, 27 Apr 2011 04:58:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [stable] [PATCH] [0/106] 2.6.35.13 longterm review
Message-ID: <20110427025831.GN16484@one.firstfloor.org>
References: <20110426212.641772347@firstfloor.org> <20110426200836.249fc12d@katamari>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426200836.249fc12d@katamari>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please revert the two TPM patches that went in 2.6.35.12. They cause timeouts
> that break suspend on a bunch of HP machines, and they were reverted before
> 2.6.38-final was released and therefore should have never been put in -stable.

Done. Thanks.
-Andi
