Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab2CGO44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 09:56:56 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46925 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114Ab2CGO4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 09:56:55 -0500
MIME-Version: 1.0
In-Reply-To: <20120305081144.GC7366@moon>
References: <20120305081144.GC7366@moon>
Date: Wed, 7 Mar 2012 18:56:54 +0400
X-Google-Sender-Auth: R3EHbMHUi2hqvrYT1_7zURf75is
Message-ID: <CAM5jBj7yFc+CH-KNeh3BBct6P2muWrEQM6rhdVF4ExaHOXXA0g@mail.gmail.com>
Subject: Re: [RFC] c/r: prctl: Add ability to get clear_tid_address
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Vagin <avagin@openvz.org>, Pedro Alves <palves@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 12:11 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> Hi guys,
>
> there were a converation about ability to retrieve task::clear_tid_address
> (https://lkml.org/lkml/2012/2/3/116) via ptrace call, which was found as being
> a bit inappropriate. So we've switched to prctl interface instead. What do
> you think? Did I miss something? Comments are welcome
>

This patch has a typo, so ignore it please. I'll resend it in another series.
