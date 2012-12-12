Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab2LLPlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 10:41:31 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:53073 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab2LLPla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 10:41:30 -0500
MIME-Version: 1.0
In-Reply-To: <10591713.1pVYGV5bcJ@lx-vladimir>
References: <1352895463-22851-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1355257444.24219.7.camel@joe-AO722> <20121211225555.GC15974@pogo> <10591713.1pVYGV5bcJ@lx-vladimir>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 12 Dec 2012 07:41:07 -0800
X-Google-Sender-Auth: sl-3t5wx4goLTOaxP-FNxZDQc28
Message-ID: <CAB=NE6VJTsB1uZotaP-9bFOy-ZeX1EagWV=jLiujZJU4iu+kiQ@mail.gmail.com>
Subject: Re: [RFC] dynamic_debug: introduce debug_hex_dump()
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Joe Perches <joe@perches.com>, Greg KH <gregkh@linuxfoundation.org>,
        Jason Baron <jbaron@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 1:12 AM, Vladimir Kondratiev
<qca_vkondrat@qca.qualcomm.com> wrote:
> +#define dynamic_hex_dump(prefix_str, prefix_type, rowsize,     \

wil_dynamic_hex_dump()

  Luis
