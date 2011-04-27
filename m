Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab1D0DIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 23:08:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60370 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab1D0DIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 23:08:40 -0400
Date: Wed, 27 Apr 2011 05:08:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [stable] [PATCH] [0/106] 2.6.35.13 longterm review
Message-ID: <20110427030839.GO16484@one.firstfloor.org>
References: <20110426212.641772347@firstfloor.org> <20110426202150.1bec600d@katamari>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426202150.1bec600d@katamari>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 08:21:50PM -0400, Chuck Ebbert wrote:
> On Tue, 26 Apr 2011 14:12:37 -0700 (PDT)
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > 
> 
> Also please revert the patch "fix-cred-leak-in-af_netlink" from 2.6.35.12.
> The proper fix was "af_netlink-add-needed-scm_destroy-after-scm_send" which
> was also added in that release. Here's a revert patch:

Done.
-Andi
