Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab1FHKqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:46:37 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61859 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab1FHKqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:46:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xuSbJ1Bhp6xFhlHUcZifIJmFE3d3+ILza5K0zvijNiFzjfjj53NCT5VDHkLc/zBUZ2
         f9E1aAgAGxkfNNhAZoUtigDtXABF/P23YGk0rEIbAvN5ixqiMfwBH697RtiLbP8HOz0A
         TAD468QhH9lErymR1m4ON/QaorvR6IE1/X5+M=
MIME-Version: 1.0
In-Reply-To: <3838457.LEWxWdrTRM@donald.sf-tec.de>
References: <20110602142242.GA4115@maxin>
	<BANLkTimYw-WAK3Hd21XQWrjBn_1+wRMzUQ@mail.gmail.com>
	<3838457.LEWxWdrTRM@donald.sf-tec.de>
Date: Wed, 8 Jun 2011 11:46:34 +0100
Message-ID: <BANLkTi=LcCiy=wroAuDdcfe3QnfXxke0ww@mail.gmail.com>
Subject: Re: [PATCH] mm: dmapool: fix possible use after free in dmam_pool_destroy()
From: Maxin B John <maxin.john@gmail.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, dima@android.com, willy@linux.intel.com,
        segooon@gmail.com, tj@kernel.org, jkosina@suse.cz, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 7, 2011 at 7:05 PM, Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:
> Maxin B John wrote:
>
>> Could you please let me know your thoughts on this patch ?
>
> Makes absolute sense to me.
>
> Reviewed-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

Thanks a lot for reviewing the patch. Should I merge these two patches
and re-send it as a single one ?

Please let me know your opinion.

Warm Regards,
Maxin
