Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab0LMJNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 04:13:51 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:34081 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab0LMJNt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 04:13:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=KxN6WGrUzP0GOF5+806NkZvjNAAAEKPTQzuGD8BNKYpqjgjA+KN2YF223r+MRahzwz
         AJA5Fy2m6095zxk/XT+U9OPX5csbKJPrmllmzinbh95nV8YhKfk8eOSDM4bM3vVD9vSk
         6kg8X1q3uqA4m7TQnk8ZcF0lh5amsqxkX/xUk=
MIME-Version: 1.0
In-Reply-To: <4D05E2A5.8070204@redhat.com>
References: <201012131244.547034648@firstfloor.org> <20101212234644.B05DAB27BF@basil.firstfloor.org>
 <4D05DC98.40105@redhat.com> <044a861a2279c7e3e328c73e6694fbf3.squirrel@www.firstfloor.org>
 <4D05E096.6060307@redhat.com> <74ff92a8c4cf72e42e7559de72e77b52.squirrel@www.firstfloor.org>
 <4D05E2A5.8070204@redhat.com>
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Date: Mon, 13 Dec 2010 10:13:28 +0100
Message-ID: <AANLkTikcYAaxrdRR_i3p5o2tegEVM=0ajuihwu+C5eoK@mail.gmail.com>
Subject: Re: [PATCH] [104/223] KVM: Write protect memory after slot swap
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, mst@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 10:08 AM, Avi Kivity <avi@redhat.com> wrote:
> I don't have an objection to the patch, rather to the methodology where
> stable kernels are more or less totally untested.  I would like at least the
> kvm part to see some testing before it sees users.  The process we worked
> out with Greg is:
>
> - Greg rejects kvm patches (but not virtio etc) pointing submitters to the
> kvm maintainers
> - The kvm maintainers collect stable kvm patches and autotest them
> - They then submit the patches to stable@
>
> The process is slower than the standard stable process but results in
> something that is less likely to fail.

But all the patches tagged for -stable are supposed to be already
upstream and therefore well tested.
What am I missing?

Regards,
-- 
Paolo
