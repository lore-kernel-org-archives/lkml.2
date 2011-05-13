Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab1EMCqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 22:46:19 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49471 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1EMCqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 22:46:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Q4s8+/LPo3oBak8HDiStIRZtSTLufryRv5EjkH2W0FFr9xVEzVcQVCnLnI8MpdASZn
         Qw3vaKMAbA7kEqxegEIM8zbVTZDNiZyZvpHyNasm1efowk+FsKpn+PJ7TLqm1n4sfaOZ
         rFIevzKMXMCsZ6gJcium7jH2AXSedkt7/8RrU=
MIME-Version: 1.0
In-Reply-To: <20110426105724.F367.A69D9226@jp.fujitsu.com>
References: <20110426105045.F359.A69D9226@jp.fujitsu.com> <20110426105518.F35D.A69D9226@jp.fujitsu.com>
 <20110426105724.F367.A69D9226@jp.fujitsu.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 12 May 2011 22:45:56 -0400
Message-ID: <BANLkTinGLWmCk208FvxRWSsGLhOayJ9gaQ@mail.gmail.com>
Subject: Re: (resend) [PATCH 2/4] blackfin: don't touch cpu_possible_map and
 cpu_present_map directly
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 21:55, KOSAKI Motohiro wrote:
> We plan to remove cpu_possible_map and cpu_present_map later and we
> have proper init_cpu_possible() and init_cpu_present() APIs.
>
> Therefore this patch rewrites platform_init_cpus and platform_prepare_cpus
> by their APIs.

ive merged this patch now, thanks
-mike
