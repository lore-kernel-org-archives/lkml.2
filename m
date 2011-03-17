Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab1CQGXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 02:23:42 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53457 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab1CQGXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 02:23:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=unuymZ0ETcCnxd0CZN+CrfRgtGo+1ih6cWY5bNRjHhmf7df/SlaFwDFFjljvjPH9+h
         s0Bs+hFV7HxK6tFPV+qQ4SDpJx1vLsX4cJ+bP9AXgGSJbRgPkPkMXD7igNgMmZ4udHTY
         549LSrRT+isMqQvyvT9QTh7SltoBgwMwdNHQA=
MIME-Version: 1.0
In-Reply-To: <20110316223631.20091.qmail@science.horizon.com>
References: <alpine.DEB.2.00.1103161352150.11002@chino.kir.corp.google.com>
	<20110316223631.20091.qmail@science.horizon.com>
Date: Thu, 17 Mar 2011 08:23:39 +0200
X-Google-Sender-Auth: _fZK1xTIkkLbeYAG6Y3hEVYL6zI
Message-ID: <AANLkTikDAEuTcrgo0YcUO40A9x5jaL-d+ZPviCXANe3r@mail.gmail.com>
Subject: Re: [PATCH 5/8] mm/slub: Factor out some common code.
From: Pekka Enberg <penberg@kernel.org>
To: George Spelvin <linux@horizon.com>
Cc: rientjes@google.com, herbert@gondor.hengli.com.au,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, mpm@selenic.com,
        penberg@cs.helsinki.fi
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George!

On Thu, Mar 17, 2011 at 12:36 AM, George Spelvin <linux@horizon.com> wrote:
> Um, can you name a (64-bit) architecture on which 32-bit is more
> expensive than 64-bit?

I certainly don't but I'd still like to ask you to change it to
'unsigned long'. That's a Linux kernel idiom and we're not going to
change the whole kernel.

                        Pekka
