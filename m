Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1LFXWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 18:22:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49440 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1LFXWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 18:22:04 -0500
MIME-Version: 1.0
In-Reply-To: <20111206225315.GA20459@moon>
References: <20111205182010.GV14515@moon>
	<20111206140833.3b43fbeb.akpm@linux-foundation.org>
	<20111206221515.GP29781@moon>
	<20111206225315.GA20459@moon>
Date: Tue, 6 Dec 2011 15:22:03 -0800
X-Google-Sender-Auth: reDUufTKmlgLKATaAyvS6v5_hkE
Message-ID: <CAGXu5j+RENTABtLqq4Vv4XOXStfw6rqpaKrtUMwFAZ5VCEwr8g@mail.gmail.com>
Subject: Re: [PATCH] fs, proc: Add start_data, end_data, start_brk members to
 /proc/$pid/stat v2
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 2:53 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> +  start_data    address above which program data is placed
> +  end_data      address above which program data is placed

Should the latter be "address below which program data is placed"?

-Kees

-- 
Kees Cook
ChromeOS Security
