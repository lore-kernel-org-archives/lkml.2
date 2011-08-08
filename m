Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab1HHDBV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 23:01:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57082 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab1HHDBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 23:01:20 -0400
MIME-Version: 1.0
In-Reply-To: <1311602888-2389-1-git-send-email-bookjovi@gmail.com>
References: <1311602888-2389-1-git-send-email-bookjovi@gmail.com>
Date: Mon, 8 Aug 2011 11:01:19 +0800
Message-ID: <CACV3sbKNgbqX+W05mp0H0Etggext9tRx4bfPA+pT8sgudpoy5Q@mail.gmail.com>
Subject: Re: [PATCH] perf: fix coredump caused by introduce of probe module option
From: Jovi Zhang <bookjovi@gmail.com>
To: acme@ghostprotocols.net, acme@redhat.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 10:08 PM,  <bookjovi@gmail.com> wrote:
> From: root <root@localhost.localdomain>
>
> perf will coredump if user don't give "-m" option in probe command,
> this patch fix it.
>
> [root@localhost perf]# ./perf probe --add='PROBE'
> Segmentation fault (core dumped)
>
> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
> ---
>  tools/perf/util/probe-event.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
>

Hi acme,
   Can this patch go through your tree?
   (Get rid of "From" field, that's suck. :))

.jovi
