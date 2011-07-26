Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab1GZH1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 03:27:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65293 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1GZH1F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 03:27:05 -0400
MIME-Version: 1.0
In-Reply-To: <1311630170-26057-17-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com> <1311630170-26057-17-git-send-email-jim.cromie@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 26 Jul 2011 09:26:44 +0200
X-Google-Sender-Auth: tBrYnt31karbgU68nfdzHjP4CpY
Message-ID: <CAO+b5-rk0uuRcVDDkAbNRBOhXBUyFOF8MqaUWfueP2C0=SeOXQ@mail.gmail.com>
Subject: Re: [PATCH 16/25] dynamic_debug: require 'a' flag to explicitly mark
 pending queries
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 11:42 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
> +       if (!q1->module ^ !q2->module ||
> +               !q1->filename ^ !q2->filename ||
> +               !q1->function ^ !q2->function ||
> +               !q1->format ^ !q2->format)
> +               return false;  /* a match-spec set/unset state differs */

I'd suggest to use "!=" here instead of "^" when testing booleans for
inequality. At least for me that would make the above code easier to
read.

Bart.
