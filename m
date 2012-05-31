Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab2EaHus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 03:50:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33397 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab2EaHuq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 03:50:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAHGf_=rT+X9PpJhfr=1GdRQ-5GALUHbt3txJCMDnus_C7Pkcug@mail.gmail.com>
References: <1336431315-29736-1-git-send-email-andi@firstfloor.org>
	<1338429749-5780-1-git-send-email-tdmackey@twitter.com>
	<20120531042249.GG9850@tassilo.jf.intel.com>
	<CAHGf_=rT+X9PpJhfr=1GdRQ-5GALUHbt3txJCMDnus_C7Pkcug@mail.gmail.com>
Date: Thu, 31 May 2012 10:50:45 +0300
X-Google-Sender-Auth: QMWUirgTN6rE7aBTgxr95uTgsYo
Message-ID: <CAOJsxLFmoh6OCtJmFdKdYLGF5j4GD_N8oxR=A6NF_DHVSCBAUg@mail.gmail.com>
Subject: Re: [PATCH v4] slab/mempolicy: always use local policy from interrupt context
From: Pekka Enberg <penberg@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>, David Mackey <tdmackey@twitter.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, cl@linux.com,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 12:22 AM, Andi Kleen <ak@linux.intel.com> wrote:
>>> [tdmackey@twitter.com: Rework patch logic and avoid dereference of current
>>> task if in interrupt context.]
>>
>> avoiding this reference doesn't make sense, it's totally valid.
>> This is based on a older version. I sent the fixed one some time ago.

On Thu, May 31, 2012 at 7:59 AM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
> Where? I think David's version is most cleaner one.
>
>  Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Monsieur Lameter, Monsieur Rientjes, ACK/NAK?
