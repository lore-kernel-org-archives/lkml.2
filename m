Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab1GZHOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 03:14:03 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:37910 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab1GZHOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 03:14:00 -0400
MIME-Version: 1.0
In-Reply-To: <1311630170-26057-12-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com> <1311630170-26057-12-git-send-email-jim.cromie@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 26 Jul 2011 09:13:39 +0200
X-Google-Sender-Auth: bquq63ETCPRv68BZYXO6ipjDlh8
Message-ID: <CAO+b5-qS-rthTu7cFSu9JdMa7ceqF8_XWV65412ABWaENKFrXA@mail.gmail.com>
Subject: Re: [PATCH 11/25] dynamic_debug: factor show_ddebug_query out of ddebug_parse_query
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 11:42 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
> +static char *prbuf_query;

Please drop this.

Thanks,

Bart.
