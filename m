Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab0FDG5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 02:57:01 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:42876 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab0FDG47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 02:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Rtlp0+NiWwwCBGExSD41P2rPpfwGu94h600alf9tVToCP5ohBY6zq2vnEiPM0EAhVd
         ie+pHrpKMA5YsS3gHYNKBPrjsQytHIHbw6NjP+iF9CH02kLH3Yt+m3jqc2OlKpfxJxh1
         Mw+2iVxG2q2uA2Rnkr26gk1z75ePswluSA5jU=
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1006041052450.1003@tundra.namei.org>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
	<alpine.LRH.2.00.1005311017530.24571@tundra.namei.org>
	<AANLkTil8LHjRT_PMosymmtBb1pxIzkBaWC0ef35DCBUU@mail.gmail.com>
	<AANLkTil7WvVZ-3zpA0E--fUcHTqul3pnXnPm1xXn_vlH@mail.gmail.com>
	<1275420536.28134.37.camel@localhost.localdomain>
	<alpine.LRH.2.00.1006041052450.1003@tundra.namei.org>
Date: Fri, 4 Jun 2010 11:56:59 +0500
Message-ID: <AANLkTinDRHqf4_pidFdmfqb4r_xJbFbM2DN-40Xva6re@mail.gmail.com>
Subject: Re: [PATCH 00/14] EVM
From: Shaz <shazalive@gmail.com>
To: James Morris <jmorris@namei.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       securityengineeringresearchgroup 
	<securityengineeringresearchgroup@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 5:57 AM, James Morris <jmorris@namei.org> wrote:
> On Tue, 1 Jun 2010, Mimi Zohar wrote:
>
>> SELinux, Smack, Capabilities, and IMA all use extended attributes. The
>> purpose of EVM is to detect offline tampering of these security extended
>> attributes.
>
> One issue mentioned to me off-list is that if EVM is only protecting
> against offline attacks, why not just encrypt the entire volume ?

Are you sure that EVM protects against offline attacks only?

Why and why not encrypt the whole volume?

> This would provide confidentiality and integrity protection for all data
> and metadata, rather than just integrity for xattr metadata.


-- 
Shaz
