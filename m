Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab0LARzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:55:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46241 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab0LARzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:55:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=j7iagqKnDolyzH4QBrd4J6S3PmKJwFO5R3gctg52Qdz3YpQ5RuYxFDcdLOThUL5ud0
         zwijnjBKo6ZHzPgQaku8mwEHMl6qYzyeEPamyOr7yLShtcY5LFcvY+xzS9i/U75VHmJE
         1RAq3kGsVlYtvgflmJkZ+jdGg990zAQDeoeTE=
MIME-Version: 1.0
In-Reply-To: <20101201165418.GU5063@radis.liafa.jussieu.fr>
References: <1291216245-18574-1-git-send-email-virtuoso@slind.org>
	<1291216245-18574-2-git-send-email-virtuoso@slind.org>
	<20101201165418.GU5063@radis.liafa.jussieu.fr>
Date: Wed, 1 Dec 2010 12:54:59 -0500
X-Google-Sender-Auth: -VZFfKKQpXMfYLpzNLhDKRWFec0
Message-ID: <AANLkTikqDpAnw1zaRCJO-yjq5N2qNs6P_SNodHrv2gDg@mail.gmail.com>
Subject: Re: [PATCH 1/4] drm: fix headers to include linux/types.h
From: =?UTF-8?Q?Kristian_H=C3=B8gsberg?= <krh@bitplanet.net>
To: Julien Cristau <jcristau@debian.org>
Cc: Alexander Shishkin <virtuoso@slind.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 1, 2010 at 11:54 AM, Julien Cristau <jcristau@debian.org> wrote:
> On Wed, Dec  1, 2010 at 17:10:42 +0200, Alexander Shishkin wrote:
>
>> For headers that get exported to userland and make use of u32 style
>> type names, it is advised to include linux/types.h.
>>
>> This fixes 5 headers_check warnings.
>>
> How many times does this need to be NAKed?  These headers are shared
> with the BSDs, and they include drm.h which has the linux/types.h
> include on linux already.

I'll NAK it too, if that helps.

Kristian
