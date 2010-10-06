Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab0JFLTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 07:19:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36951 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab0JFLTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 07:19:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=CKVWB7BeO56WS2q2/wTG0Y+k8CZuiijD58l9PimD2OB7/QeMU4As5nVoTLa3r4XVYZ
         yQ8hgFCnOCQ0C5vLbVMosg1meNDkhQL895d0C824QXaHv/dDseCaAs0T84eg96SZrhhS
         4WQhrdVBCzujRkSJ7cPnSmelTVGBjlwAE+It8=
MIME-Version: 1.0
In-Reply-To: <4CAC577F.9040401@rsk.demon.co.uk>
References: <20101005185725.088808842@linux.com>
	<AANLkTinPU4T59PvDH1wX2Rcy7beL=TvmHOZh_wWuBU-T@mail.gmail.com>
	<4CAC577F.9040401@rsk.demon.co.uk>
Date: Wed, 6 Oct 2010 14:19:13 +0300
X-Google-Sender-Auth: o6dwv-lx2e0h-SCESgnrx1boIQ4
Message-ID: <AANLkTikr9B5Yb+Owe3t+Rb8KBO33DE=9YBQZ_1+Gwcu8@mail.gmail.com>
Subject: Re: [UnifiedV4 00/16] The Unified slab allocator (V4)
From: Pekka Enberg <penberg@kernel.org>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Mel Gorman <mel@csn.ul.ie>, npiggin@kernel.dk,
        yanmin_zhang@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 6, 2010 at 2:03 PM, Richard Kennedy <richard@rsk.demon.co.uk> wrote:
> What tree are these patches against ? I'm getting patch failures on the
> main tree.

The 'slab/next' branch of slab.git:

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=summary
