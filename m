Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab1FKJuH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 05:50:07 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48783 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab1FKJuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 05:50:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=df+/teC+ml9W3o/XVczoC8YNu1OwhLNSca9jwBaaQ1YTrbseGyLgTDK8qrPhT95yNU
         mxLCW6eXTzNJb3sV7UPin3edDUepQBcfevRBupfWic78M58T/TZNzVN1R6J6TL4GgaRm
         yCD7w6ajS2ipgoP+/vyosfgalsDTVjUmz/jeA=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1106101016420.30968@router.home>
References: <20110601172543.437240675@linux.com>
	<20110601172614.173427964@linux.com>
	<4DF09827.7070809@cs.helsinki.fi>
	<alpine.DEB.2.00.1106101016420.30968@router.home>
Date: Sat, 11 Jun 2011 12:50:03 +0300
X-Google-Sender-Auth: 9EG1-j3SntxDkwatU4UDIy946Lk
Message-ID: <BANLkTikHOsvR-KXZ-VQvpAaMgrNOR0sB3g@mail.gmail.com>
Subject: Re: [slubllv7 04/17] x86: Add support for cmpxchg_double
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>, tj@kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 6:17 PM, Christoph Lameter <cl@linux.com> wrote:
> On Thu, 9 Jun 2011, Pekka Enberg wrote:
>
>> Tejun, I'm going to queue this series for linux-next in the next few days.
>> Could you either pick up this patch so I can pull from your tree or
>> alternatively, is it OK to queue this through slab.git?
>
> This patch is not related to percpu functionality. Tejun does general x86
> patches?

Oh, I don't know - but I definitely need more ACKs to even consider
pushing this through slab.git.
