Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab0EPQpM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 12:45:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57955 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab0EPQpJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 12:45:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mCa0EA8220CVFRCuNKcTeQOo3C40ZGYuCy4hweGxv1ru4b6BCmkle1WLWuISCdu9aF
         ssmHpcbOlTRjmGmBTfQAEU89/hwoMHBXAYz4Fzo3cwVTGWEDdisvkwXmayNG9yEHuckU
         tnxtzfJPru4JEl23pDNMUkF6JrfiWLq3i+u7E=
MIME-Version: 1.0
In-Reply-To: <FA04A0D0-4BAF-4E1D-B8E8-3148E290009F@coraid.com>
References: <Pine.LNX.4.64.1005152323310.21345@ask.diku.dk>
	 <FA04A0D0-4BAF-4E1D-B8E8-3148E290009F@coraid.com>
Date: Sun, 16 May 2010 19:38:55 +0300
X-Google-Sender-Auth: M0GmiRIp17pjQuoG6IMcfsppfHY
Message-ID: <AANLkTinise7NM85whW99-aU_DsC2gZRV1o85GO01Egag@mail.gmail.com>
Subject: Re: [PATCH 35/37] drivers/block/aoe: Use kmemdup
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ed Cashin <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Julia Lawall <julia@diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 16, 2010 at 3:42 PM, Ed Cashin <ecashin@coraid.com> wrote:
> (Because the argument about whether this kind of change
> adds value in general has already taken place.  I'd say no, but that's
> based on a maybe faulty idea that if folks weren't doing this they'd have
> more time for reviewing patches, etc.)

It makes kernel text size smaller so yes, it adds value.
