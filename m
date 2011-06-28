Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab1F1Gld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 02:41:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42446 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab1F1Gj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 02:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NGXJJUxzVKfVQcev3ibTV0VWfgTR3VY8vWXnt5RXjIIwMk8UQm6vkkteq98OS8Jhxr
         Emh1aUNfMYjc91SwIn9jxwfEy3jn1W+e9YJEMrdvTxpnwUGHNodxMJtc/KI505SzZ5kz
         Ln6JalQV0qcOz51NE+qHsJgjSS17bm7l0hACQ=
MIME-Version: 1.0
In-Reply-To: <1309224113-21818-4-git-send-email-sergiu@chromium.org>
References: <1309224113-21818-1-git-send-email-sergiu@chromium.org>
	<1309224113-21818-4-git-send-email-sergiu@chromium.org>
Date: Tue, 28 Jun 2011 08:39:28 +0200
Message-ID: <BANLkTimhEE6TXqnS+eLx863+rjJxqzu19A@mail.gmail.com>
Subject: Re: [PATCH 3/3] char drivers: ramoops record_size module parameter
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Sergiu Iordache <sergiu@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/6/28 Sergiu Iordache <sergiu@chromium.org>:
> The size of the dump is currently set using the RECORD_SIZE macro which
> is set to a page size. This patch makes the record size a module
> parameter and allows it to be set through platform data as well to allow
> larger dumps if needed.
>
> Change-Id: Ie6bd28a898dab476abf34decb0eecc42122f17ce
> Signed-off-by: Sergiu Iordache <sergiu@chromium.org>
> ---

the idea can be valid, but you have to add some check to set the
record size. It'd be better to add a lower and upper bound and to
check for it's power of two.

Marco
