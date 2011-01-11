Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab1AKLUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:20:31 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49329 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab1AKLU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:20:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=K79fuJEYAlxM7YbmxPtJG5NrMuFILHNgzGuuG3GNPQuI8ygfQoUyoBTPJHqRNdXhZJ
         Gu9dAZzRYX59qYBVVb7jIYvrEldOO6djEEAjQYYbQ3QJMDByRx8aFOXBr2iZYuerbIZG
         cuWBhYjJoQXeWP7+r7nVa9QAjQI9Jj3hL6mCY=
MIME-Version: 1.0
In-Reply-To: <20110111111345.GA23544@shutemov.name>
References: <20110110105433.GA17881@shutemov.name>
	<alpine.DEB.2.00.1101101051260.12243@router.home>
	<20110110193117.GA20027@shutemov.name>
	<4D2C279D.5050309@redhat.com>
	<4D2C3115.9030301@redhat.com>
	<20110111111345.GA23544@shutemov.name>
Date: Tue, 11 Jan 2011 13:20:27 +0200
X-Google-Sender-Auth: AKH4d-Wp_Lu52plIZtSbd-K2GhU
Message-ID: <AANLkTim4VM7GjGonXwTs9zwuaOTzegbNKHLpN1QEE1th@mail.gmail.com>
Subject: Re: BUG: sleeping function called from invalid context at mm/slub.c:793
From: Pekka Enberg <penberg@kernel.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Avi Kivity <avi@redhat.com>, Christoph Lameter <cl@linux.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 1:13 PM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
>> Please try out the attached patch.
>
> It helps.
>
> Reported-and-tested-by: Kirill A. Shutemov <kas@openvz.org>

Acked-by: Pekka Enberg <penberg@kernel.org>
