Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab1F1G3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 02:29:32 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35518 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab1F1G16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 02:27:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LgJaTQznZm6/CIxNDCYlB4CwvSnhMdfWt3fc4+3WTSNS3MibABOnQtKJOO8PebIWPG
         ovWjyAOsVq4S1u43ERBa8nGCcD+pJwheDzL7S7adbofi084JfR4tRZbGsEH7SdQlpbEP
         8ilaPi/WreArL9yZ7KFJbE/ZWThDcsjjxt0Sc=
MIME-Version: 1.0
In-Reply-To: <1309224113-21818-1-git-send-email-sergiu@chromium.org>
References: <1309224113-21818-1-git-send-email-sergiu@chromium.org>
Date: Tue, 28 Jun 2011 08:27:56 +0200
Message-ID: <BANLkTinWY2Cbk3yR6DTC329muJev9dyt_g@mail.gmail.com>
Subject: Re: [PATCH 0/3] char drivers: ramoops improvements
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
> This series of patches improves ramoops by allowing it to be used only with
> module parameters (without having to set a platform device externally),
> adding a new parameter for the dump size in order to be able to save larger
> logs and updating the platform data structure to allow setting all the
> options through it.
>

there are already a couple of patches in the Andrew's tree, you can
look at them.

Marco
