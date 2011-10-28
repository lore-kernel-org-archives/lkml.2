Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411Ab1J1VQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:16:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42539 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab1J1VQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:16:53 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:3620]
In-Reply-To: <20111028202216.GA21504@hmsreliant.think-freely.org>
References: <1319832688-30336-1-git-send-email-scott@netsplit.com>
	<20111028202216.GA21504@hmsreliant.think-freely.org>
Date: Fri, 28 Oct 2011 14:16:52 -0700
Message-ID: <CA+bD78itD3dAZiA9eWbB7QXsub3phmareesHEmydawV+AaQNNw@mail.gmail.com>
Subject: Re: [PATCH] coredump: wait on the core pattern umh at least once
From: Scott James Remnant <scott@netsplit.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, Mandeep Singh Baines <msb@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 1:22 PM, Neil Horman <nhorman@tuxdriver.com> wrote:

> Seems reasonable to me.
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
>

One thing I'm not sure about is whether this will work if there are
actually no readers really reading, just the incremented one. It
seemed to work just fine in testing, but I'd be more comfortable if
someone else could confirm.

Scott
