Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab0KORQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:16:52 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50016 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932932Ab0KORQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:16:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ak8SCh8EKQXh8J6Ta/oLuQs+BmkwlVARIyl+cEncueFl23u9pIfKAm662dx4eqPXMj
         OBxVwcNSW2Azc2RBeQPFJWN+vvA2d3Gj/1jVgK7PfDRQ2h/2/sTyAek9smNYBYIjUlzG
         oPZso0erOc+joeD5bLRCCMP3a1bCv7H+jV4O0=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1011151056380.2939@x980>
References: <alpine.LFD.2.00.1010230116590.29399@localhost.localdomain>
	<alpine.LFD.2.00.1010240004180.23060@localhost.localdomain>
	<alpine.LFD.2.00.1010262312090.3209@localhost.localdomain>
	<alpine.LFD.2.00.1011151056380.2939@x980>
Date: Mon, 15 Nov 2010 15:16:47 -0200
X-Google-Sender-Auth: dv-FaEzFe5ifJ6rw6HtQJdSfwZc
Message-ID: <AANLkTi=FK0em5qYV0wf_SMpbC_SrOYYB0i0w1L5WS+Ec@mail.gmail.com>
Subject: Re: [PATCH RESEND] tools: add power/x86/turbostat - v2
From: Otavio Salvador <otavio@ossystems.com.br>
To: Len Brown <lenb@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-pm@lists.linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 2:01 PM, Len Brown <lenb@kernel.org> wrote:
> From: Len Brown <len.brown@intel.com>
>
> turbostat displays actual processor frequency on modern
> Intel processors.  Note that this capability depends on free-running
> APERF and MPERF MSRs, which were cleared by the acpi_cpufreq
> driver up through Linux-2.6.29.
>
> On Intel Core i3/i5/i7 (Nehalem) and newer processors,
> turbostat displays residency in idle power saving states.
>
> See the comments in the source code for example usage.
>
> Signed-off-by: Len Brown <len.brown@intel.com>
> Reviewed-by: Otavio Salvador

Reviewed-by: Otavio Salvador <otavio@ossystems.com.br>

-- 
Otavio Salvador                  O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854         http://projetos.ossystems.com.br
