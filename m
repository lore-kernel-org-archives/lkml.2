Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab1CINQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 08:16:19 -0500
Received: from smtp-out.google.com ([216.239.44.51]:49775 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab1CINQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 08:16:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JWlZa2LuYmhPy3aI3A5MEdbHplq9TLXauXpEYFSTOJqHOSkj6fYm4qnrdzh9+0mPUv
         ktgw5traOD4feEABeAlA==
MIME-Version: 1.0
In-Reply-To: <1299630721-4337-1-git-send-email-wilsons@start.ca>
References: <1299630721-4337-1-git-send-email-wilsons@start.ca>
Date: Wed, 9 Mar 2011 05:09:09 -0800
Message-ID: <AANLkTikTEi8uKeCfPLoenNx9g6fLyAqNqfVdR=4KzNB3@mail.gmail.com>
Subject: Re: [PATCH 0/5] make *_gate_vma accept mm_struct instead of task_struct
From: Michel Lespinasse <walken@google.com>
To: Stephen Wilson <wilsons@start.ca>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Paul Mundt <lethal@linux-sh.org>, Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 8, 2011 at 4:31 PM, Stephen Wilson <wilsons@start.ca> wrote:
> Morally, the question of whether an address lies in a gate vma should be asked
> with respect to an mm, not a particular task.
>
> Practically, dropping the dependency on task_struct will help make current and
> future operations on mm's more flexible and convenient.  In particular, it
> allows some code paths to avoid the need to hold task_lock.

Reviewed-by: Michel Lespinasse <walken@google.com>

May I suggest ia32_compat instead of just compat for the flag name ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
