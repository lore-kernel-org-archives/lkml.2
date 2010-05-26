Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934145Ab0EZGTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 02:19:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:1983 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934116Ab0EZGTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 02:19:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Nt5ATYomAxR0MMtrDPahUyw37+1guZ0hJ7qmBvo5Iu5a/YCcijmYc13/jJU42fm98a
         jSeBddmGwL9wp/0HhPkXlGezP+c8rPi5WQcpPZqxHS5JsglJmjyUzTWcYdN+/1he74W8
         DccJU+J+KuR8sPHg/ULECB0RHvMXwaxPMFkjE=
MIME-Version: 1.0
In-Reply-To: <20100525201259.GA5370@nowhere>
References: <1274815906.9757.83.camel@cndougla-ubuntu>
	<20100525201259.GA5370@nowhere>
Date: Wed, 26 May 2010 09:19:37 +0300
X-Google-Sender-Auth: INjb6f9xK8srjRzfroNGsU4a7jk
Message-ID: <AANLkTinuHB9gPLBZs_QsHqOm6Y5nR91P_gFlVBXa-ilJ@mail.gmail.com>
Subject: Re: Tracing configuration review
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chase Douglas <chase.douglas@canonical.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Soeren Sandmann <sandmann@daimi.au.dk>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 11:13 PM, Frederic Weisbecker
<fweisbec@gmail.com> wrote:
>> # CONFIG_KMEMTRACE is not set (Kconfig says N if unsure)
>
> Deprecated. We have the kmem trace event that are a full replacement now.
> Pekka, Gabriel, can we remove it now?

I don't think ftrace supports boot-time tracing which kmemtrace did.
That said, I was probably the only one actually using the feature so
maybe we can just nuke kmemtrace at this point...
