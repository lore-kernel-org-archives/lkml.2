Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003Ab2KNRIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 12:08:48 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:56049 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932188Ab2KNRIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:08:47 -0500
Message-ID: <1352912932.9388.23.camel@joe-AO722>
Subject: Re: [RFC] dynamic_debug: introduce debug_hex_dump()
From: Joe Perches <joe@perches.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org,
        "Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
        Jason Baron <jbaron@redhat.com>, Jim Cromie <jim.cromie@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 14 Nov 2012 09:08:52 -0800
In-Reply-To: <4818336.JicdpLVKSo@lx-vladimir>
References: <1352895463-22851-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1352895463-22851-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1352900468.9388.20.camel@joe-AO722> <4818336.JicdpLVKSo@lx-vladimir>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-14 at 18:18 +0200, Vladimir Kondratiev wrote:
> And, here it goes (can I call it PATCH?):

Don't see why not.

> From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
[]
> Introduce debug_hex_dump() that can be dynamically controlled, similar to
> pr_debug.
> 
> Also, make print_hex_dump_bytes() dynamically controlled

print_hex_dump_debug might be a better name than
debug_hex_dump because it's more similar to the other
print_hex_dump<_foo> names.


