Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab1F1K1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:27:25 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58064 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476Ab1F1KZQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:25:16 -0400
MIME-Version: 1.0
In-Reply-To: <1309244992-2305-9-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com> <1309244992-2305-9-git-send-email-jim.cromie@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 28 Jun 2011 12:24:56 +0200
X-Google-Sender-Auth: IXWHWO_0RgOilXLdR0rS0nPKLk4
Message-ID: <BANLkTikpuHNBU5yJwwxsPLmdPyG1TNj97Q@mail.gmail.com>
Subject: Re: [PATCH 08/11] dynamic_debug: return int from ddebug_change
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org, gnb@fmeh.org, jbaron@redhat.com,
        gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 9:09 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> @@ -425,6 +424,7 @@ static int ddebug_exec_query(char *query_string)
>  #define MAXWORDS 9
>        int nwords;
>        char *words[MAXWORDS];
> +       int nfound;
>
>        nwords = ddebug_tokenize(query_string, words, MAXWORDS);
>        if (nwords <= 0)
> @@ -435,7 +435,8 @@ static int ddebug_exec_query(char *query_string)
>                return -EINVAL;
>
>        /* actually go and implement the change */
> -       ddebug_change(&query, flags, mask);
> +       nfound = ddebug_change(&query, flags, mask);
> +
>        return 0;

Do these changes actually do anything, or did I miss something ?

Bart.
