Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab1LTIRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 03:17:20 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38496 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab1LTIRO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 03:17:14 -0500
MIME-Version: 1.0
In-Reply-To: <d3379e3504fcb51e666d85b0a7aef33f27e0c353.1324318997.git.jbaron@redhat.com>
References: <cover.1324318997.git.jbaron@redhat.com>
	<d3379e3504fcb51e666d85b0a7aef33f27e0c353.1324318997.git.jbaron@redhat.com>
Date: Tue, 20 Dec 2011 08:17:13 +0000
X-Google-Sender-Auth: VIYoJoAa4pGKb-9sDt7Fd_ePqTM
Message-ID: <CAO+b5-rZpHfB+OkHtsvBOaZx3tnLSCmBz=Md1+vY2hx+N2TLtA@mail.gmail.com>
Subject: Re: [PATCH 15/16] dynamic_debug: factor vpr_info_dq out of ddebug_parse_query
From: Bart Van Assche <bvanassche@acm.org>
To: Jason Baron <jbaron@redhat.com>
Cc: greg@kroah.com, jim.cromie@gmail.com, joe@perches.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 10:13 PM, Jason Baron <jbaron@redhat.com> wrote:
> From: Jim Cromie <jim.cromie@gmail.com>
>
> Factor pr_info(query) out of ddebug_parse_query, into pr_info_dq(),
> for reuse later.  Also change the printed labels: file, func to agree
> with the query-spec keywords accepted in the control file.  Pass ""
> when string is null, to avoid "(null)" output from sprintf.  For
> format print, use precision to skip last char, assuming its '\n', no
> great harm if not, its a debug msg.

pr_info_dq() or vpr_info_dq() ?

Bart.
