Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab1JaQpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 12:45:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65410 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab1JaQpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 12:45:03 -0400
MIME-Version: 1.0
In-Reply-To: <F9300DCD-387B-481A-85B2-5ED30204CADC@tuxera.com>
References: <F9300DCD-387B-481A-85B2-5ED30204CADC@tuxera.com>
Date: Mon, 31 Oct 2011 17:45:01 +0100
Message-ID: <CAO+b5-q0Mbfeb-57UsGYzjz0S=Z_Lra7o=HbpFxz83jHrvcnJA@mail.gmail.com>
Subject: Re: Deadlock due to device removal - race condition in scsi/block layer?
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Anton Altaparmakov <anton@tuxera.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/11, Anton Altaparmakov <anton@tuxera.com> wrote:
> We have seen a deadlock when doing "unplug whilst writing" testing.

Does this patch help: http://marc.info/?l=linux-scsi&m=131680195721932 ?

Bart.
