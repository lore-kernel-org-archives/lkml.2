Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab2D3MZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 08:25:28 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39468 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab2D3MZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 08:25:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120430120641.GA3111@polaris.bitmath.org>
References: <1335097300-11881-1-git-send-email-rydberg@euromail.se>
	<alpine.LNX.2.00.1204222325380.1856@pobox.suse.cz>
	<4F9D5F43.4000502@gmail.com>
	<20120430120641.GA3111@polaris.bitmath.org>
Date: Mon, 30 Apr 2012 15:25:25 +0300
Message-ID: <CALu8Fe8oaNM+77OAYbpS_4q2CTsyz6Xkgfbz248bxEap4=PQpA@mail.gmail.com>
Subject: Re: [PATCH 0/3] hid: Enable report fixup on rebind
From: Nikolai Kondrashov <spbnick@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Mon, Apr 30, 2012 at 3:06 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> The changes you propose force changes to out-of-tree-drivers, without
> any obvious benefit. Also, there is already a large set of patches on
> review based on this one. So although I agree that some renames and
> movements could clarify things, the content and timing will need some
> more thought.

OK, taking into account Jiri's comment also, I'll retry this change
after things settle down a bit.

Thanks!

Sincerely,
Nick
