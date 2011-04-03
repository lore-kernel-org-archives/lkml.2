Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1DCTD0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 15:03:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab1DCTDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 15:03:25 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=wom5GMh1gUkA:10 a=qfFVHXmYx5UA:10 a=kj9zAlcOel0A:10 a=eAWTIsOZi86Vnn5xZOjC/w==:17 a=ybZZDoGAAAAA:8 a=LWrmulaFe50X_IuVwicA:9 a=CjuIK1q_8ugA:10 a=qIVjreYYsbEA:10 a=eAWTIsOZi86Vnn5xZOjC/w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.154.172
Date: Sun, 3 Apr 2011 14:03:24 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: ntl@pobox.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Oren Laadan <orenl@cs.columbia.edu>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 05/10] Core checkpoint/restart support code
Message-ID: <20110403190324.GD15044@hallyn.com>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
 <1298936432-29607-6-git-send-email-ntl@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298936432-29607-6-git-send-email-ntl@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting ntl@pobox.com (ntl@pobox.com):
> Only a pid namespace init task - the child process produced by a call
> to clone(2) with CLONE_NEWPID - is allowed to call these.  The state

So you make this useful for your cases by only using this with
application containers - created using lxc-execute, or, more precisely,
using lxc-init as the container's init.  So a container running a stock
distro can't be checkpointed.

Is this just to keep the patch simple for now, or is there some reason
to keep this limitation in place?

-serge
