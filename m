Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab1GCIcq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 04:32:46 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37621 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab1GCIcp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 04:32:45 -0400
MIME-Version: 1.0
In-Reply-To: <1309244992-2305-10-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com> <1309244992-2305-10-git-send-email-jim.cromie@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Sun, 3 Jul 2011 10:32:24 +0200
X-Google-Sender-Auth: hBbjxze29lg0F0er_irS7WSUuo0
Message-ID: <CAO+b5-p=+_gvyXf76ELerb9HCXqCjBQq5sHCs59oMY8tU3Kd1A@mail.gmail.com>
Subject: Re: [PATCH 09/11] dynamic_debug: add_to_pending() saves non-matching
 queries for later.
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org, gnb@fmeh.org, jbaron@redhat.com,
        gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 9:09 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
>  pending_max - rw, set max pending, further pending queries are rejected

It's not clear to me why this kernel module parameter has been
introduced ? I'm afraid that this parameter will frustrate users. My
suggestion is to leave it out entirely.

Bart.
