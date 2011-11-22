Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab1KVO7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:59:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58527 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab1KVO7j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:59:39 -0500
MIME-Version: 1.0
In-Reply-To: <1321952446-7591-3-git-send-email-jj_ding@emc.com.tw>
References: <1321952446-7591-1-git-send-email-jj_ding@emc.com.tw> <1321952446-7591-3-git-send-email-jj_ding@emc.com.tw>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 22 Nov 2011 09:59:16 -0500
Message-ID: <CAMjpGUeXik3tbuDVyZMdbf9ZbG54_uo5=oOAGoFqgH8psRYQkw@mail.gmail.com>
Subject: Re: [PATCH TRIVIAL 2/5] Input: misc: use macro module_platform_driver()
To: JJ Ding <jj_ding@emc.com.tw>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, JJ Ding <dgdunix@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 04:00, JJ Ding <jj_ding@emc.com.tw> wrote:
>  drivers/input/misc/bfin_rotary.c       |   13 +------------

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
