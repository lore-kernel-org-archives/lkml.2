Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab1DAHhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 03:37:13 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:48337 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab1DAHhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 03:37:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BII+GEh2XuUTh5Py/rhHQqXULAyt6azL6ZrA/btJk7WMR9GU0OxpOJygYZXd5r8kgI
         xYAHqt4AZoLpAw88pXOIN/S+ci1951RciggNeB6qy13aAH4GbI5AgJ67PjZfaw9N1q7e
         CcAGjcno2JCa3LjO1miuhbFlGB5dvcUCj1loo=
MIME-Version: 1.0
In-Reply-To: <4D95799C.6040809@de.ibm.com>
References: <1301592656.586.15.camel@jaguar>
	<1B1AE097-4524-4026-85EC-F9A0E274FFF2@suse.de>
	<4D95799C.6040809@de.ibm.com>
Date: Fri, 1 Apr 2011 11:37:09 +0400
Message-ID: <AANLkTi=chrnHfBza9Qq8iR6AA8wWkhJkr82+ydZhpgXQ@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Carsten Otte <carsteno@de.ibm.com>
Cc: Alexander Graf <agraf@suse.de>, Pekka Enberg <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "joro@8bytes.org Roedel" <joro@8bytes.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Asias He <asias.hejun@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Carsten Otte <cotte@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 1, 2011, Carsten Otte <carsteno@de.ibm.com> wrote:
> On 31.03.2011 23:47, Alexander Graf wrote:
>
> Did you take a look at kuli?
>
> Right. If you want to take kuli as a start, and GPL is acceptable for you ;-).
> If kuli seems right, I suggest to go ahead and make an upstream git repository for it. I'd be happy to keep contributing the s390 parts to whoever feels responsible for maintaining the tree.
>
> cheers,
> Carsten
>
>
Cool! I personally didnt hear of kuli (thanks for the hint) but will
take a look. Carsten, Pekka is the primary maintainer, so if youre
interested to maintain s390 part, i think we are glad to accept it  ;)
