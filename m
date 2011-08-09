Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab1HIT6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:58:07 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53422 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1HIT6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:58:06 -0400
MIME-Version: 1.0
In-Reply-To: <CADzpL0SnZ+t6RT5iU2Ne+HEdBO1n2K51WwqaVDHXPs1CDHGk2A@mail.gmail.com>
References: <20110809131801.10649.44268.stgit@beardog.cce.hp.com>
	<CADzpL0SnZ+t6RT5iU2Ne+HEdBO1n2K51WwqaVDHXPs1CDHGk2A@mail.gmail.com>
Date: Tue, 9 Aug 2011 14:58:05 -0500
Message-ID: <CADzpL0TZfdQqoE-X-tN0SrsNSOvqJAsX8DzC46XpM_JihJY29w@mail.gmail.com>
Subject: Re: [PATCH] hpsa: fix physical device lun and target numbering problem
From: Stephen Cameron <stephenmcameron@gmail.com>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com,
        thenzl@redhat.com, akpm@linux-foundation.org, axboe@kernel.dk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 8:33 AM, Stephen Cameron
<stephenmcameron@gmail.com> wrote:

> Despite the above patch, which I do think is correct, I can still get
> a panic (on RHEL 6.1 with 2.6.31-rc1 kernel)

Er, I meant 3.1-rc1, not 2.6.31-rc1.

-- steve
