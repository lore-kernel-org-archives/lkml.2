Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab0CWCCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 22:02:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56165 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab0CWCCc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 22:02:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MM53+z+1W0sWwKqPJTecsZX+E9il+zCY5cqRGchajzt+FU/KF6aDUCQUbBUhRiLxJ1
         x3OukBc3RJpcj/vpiId4Ze+HnUfK1CfeDF402SBIQGHlJYqC8nzGUY4th3a5txMmuMGT
         bCCGR4n2bOsBom2ja7bmPuDAUGYejSCm/ycGA=
MIME-Version: 1.0
In-Reply-To: <20100322152103.86cfec45.akpm@linux-foundation.org>
References: <20100318121151.cedeb849.akpm@linux-foundation.org>
	 <4ba2f862.4902be0a.0815.0d09@mx.google.com>
	 <20100322152103.86cfec45.akpm@linux-foundation.org>
Date: Mon, 22 Mar 2010 19:02:31 -0700
Message-ID: <be233a491003221902j587fc9a9ua86cb785ebbd27cf@mail.gmail.com>
Subject: Re: [PATCH] hpet: factor timer allocate from open
From: Magnus Lynch <maglyx@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Clemens Ladisch <clemens@ladisch.de>,
       "Venkatesh Pallipadi (Venki)" <venkatesh.pallipadi@intel.com>,
       Vojtech Pavlik <vojtech@suse.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 3:21 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> Better is the plain old simple approach:
>
>
>  {
>        struct hpet_dev *devp;
>        int r;
>
>        r = hpet_alloc_timer(file);
>        if (r < 0)
>                return r;

Fine with me, thanks for doing the patch yourself.
