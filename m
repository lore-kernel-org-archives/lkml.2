Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab1BJSfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:35:43 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56377 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1BJSfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:35:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YgOM9fV0cPy/4Sb79l8aB1B/1cF5g2PK90oKgxgpretJMjp5NYhc7LQv+6Jvxhtlpr
         f4SG66Pnoz8KYbx7rWR6+1+L8Qm8b4hIyOAU/eEso2mjfdd0UmqZnw9z+YMTqmAtiwUf
         /FSVUbbPxawRYBRfwuYrtkVh+jJPDhzZjNRX8=
MIME-Version: 1.0
In-Reply-To: <AANLkTikLM=Q_p0dk3USsYtLJ6GXKZsNoQuK3J+dA_z9V@mail.gmail.com>
References: <1297340643.5512.1.camel@marge.simson.net>
	<AANLkTikLM=Q_p0dk3USsYtLJ6GXKZsNoQuK3J+dA_z9V@mail.gmail.com>
Date: Thu, 10 Feb 2011 19:35:41 +0100
Message-ID: <AANLkTimbHE9H5_vmS3=L84z=OkL0GNAxg4xOUjnco5SL@mail.gmail.com>
Subject: Re: [PATCH 01/28] sched: Remove USER_SCHED
From: Dhaval Giani <dhaval.giani@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> There were a few more patches after this which cleaned up a few things
> as well. Let me search them out and let you know the commit IDs.
>

6427462bfa50f50dc6c088c07037264fcc73eca1
32bd7eb5a7f4596c8440dd9440322fe9e686634d
571428be550fbe37160596995e96ad398873fcbd

Thanks!
Dhaval
