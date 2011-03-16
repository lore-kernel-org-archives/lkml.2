Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab1CPGYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 02:24:36 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62174 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab1CPGYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 02:24:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=RJjcY9YqIOwTCauunHsG8qVaXhMJKBHJ+L4fvvj5cwTPVFO/w/cO2MG/LFaR9BYWPF
         6MNjeewJTz5RGfLfTsCQMpT36jQlylqgNXkfatwE837CfRVTUCbMdPP+fCQeCfrG7KcF
         mtfQn61T8Ll/2MPwzfOn4JwOtYJZ1oSzthCk0=
MIME-Version: 1.0
In-Reply-To: <1300244054.3128.417.camel@calx>
References: <20110316022804.27679.qmail@science.horizon.com>
	<1300244054.3128.417.camel@calx>
Date: Wed, 16 Mar 2011 08:24:30 +0200
X-Google-Sender-Auth: HaE4pFHIXr0pKqmtYxOhrX2kAYY
Message-ID: <AANLkTimfieJ4DxSrDiA_EEqe+V3BzsFygQ=GgQBTGx0u@mail.gmail.com>
Subject: Re: [PATCH 1/8] drivers/random: Cache align ip_random better
From: Pekka Enberg <penberg@kernel.org>
To: Matt Mackall <mpm@selenic.com>
Cc: George Spelvin <linux@horizon.com>, penberg@cs.helsinki.fi,
        herbert@gondor.hengli.com.au, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 4:54 AM, Matt Mackall <mpm@selenic.com> wrote:
> On Sun, 2011-03-13 at 20:20 -0400, George Spelvin wrote:
>> Cache aligning the secret[] buffer makes copying from it infinitesimally
>> more efficient.
>
> Acked-by: Matt Mackall <mpm@selenic.com>

Acked-by: Pekka Enberg <penberg@kernel.org>
