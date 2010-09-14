Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab0INSAC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 14:00:02 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52512 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab0INR77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:59:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Lp7BAhpJwVXEnbgo7rcUVM0W6tu2vZMLbFOBd+soZjY3dG6gW7RBTxi2b3ZyEK5uIn
         fFEHdD5zjO7UbnYnPd3TsBILPOALi2oWNdbULT8UGp7Pq+o+Ycc1RNZy7QJqzwWN631p
         2kEIyIQbkMSlkwTA3TWB/zfKho/vSWe7ocF44=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1009141227430.31857@router.home>
References: <1284483964-2370-1-git-send-email-penberg@kernel.org>
	<1284483964-2370-2-git-send-email-penberg@kernel.org>
	<AANLkTinxNbBQ3phKH8aoOSCO-+3FLn=te4OAqx4J8cU+@mail.gmail.com>
	<alpine.DEB.2.00.1009141227430.31857@router.home>
Date: Tue, 14 Sep 2010 20:59:58 +0300
X-Google-Sender-Auth: lCPMHntAl0XDK97ZMpBYsZ-b6a4
Message-ID: <AANLkTim8xzipTHTCvGegkbuCoT51EZVox32xasQaq_yq@mail.gmail.com>
Subject: Re: [PATCH 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010, Pekka Enberg wrote:
>> Unfortunately this breaks "slabtop". I guess we could try some other delimiter?

On Tue, Sep 14, 2010 at 8:28 PM, Christoph Lameter <cl@linux.com> wrote:
> + ?

Looking at procps sources, slabtop and other utilities seem to think
slab cache names are limited to 64 bytes. Linus, are you OK with
adding a "+" character prefix for merged caches like you suggested in
private?

                        Pekka
