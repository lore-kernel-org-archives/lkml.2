Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab1F1KTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:19:34 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62337 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997Ab1F1KRe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:17:34 -0400
MIME-Version: 1.0
In-Reply-To: <1309244992-2305-5-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com> <1309244992-2305-5-git-send-email-jim.cromie@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 28 Jun 2011 12:17:13 +0200
X-Google-Sender-Auth: OyY8El5Aj71GnR3rmKhVWe9L0cA
Message-ID: <BANLkTikRULUhVne2ZfLJp6eBmxrS2bumqQ@mail.gmail.com>
Subject: Re: [PATCH 04/11] dynamic_debug: warn when >1 of each type of
 match-spec is given
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org, gnb@fmeh.org, jbaron@redhat.com,
        gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 9:09 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> -                       query->format = unescape(words[i+1]);
> +                       check_set(&query->format, words[i+1], "format");

Was it your intention to remove the call to "unescape" ?

Bart.
