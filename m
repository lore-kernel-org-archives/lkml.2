Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab1LFWkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:40:03 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60432 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab1LFWkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:40:00 -0500
Message-ID: <4EDE99B3.2010507@gmail.com>
Date: Tue, 06 Dec 2011 23:39:47 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v1 6/7] media: video: introduce face detection driver
 module
References: <1322838172-11149-1-git-send-email-ming.lei@canonical.com>	<1322838172-11149-7-git-send-email-ming.lei@canonical.com>	<4EDD3DEE.6060506@gmail.com> <CACVXFVPrAro=3t-wpbR_cVahzcx7SCa2J=s2nyyKfQ6SG-i0VQ@mail.gmail.com> <4EDE90A3.7050900@gmail.com>
In-Reply-To: <4EDE90A3.7050900@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 11:01 PM, Sylwester Nawrocki wrote:
[...]
>
> It might be much better as the v4l2 events are associated with the frame
> sequence. And if we use controls then you get control events for free,
> and each event carries a frame sequence number int it
> (http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-dqevent.html).

Oops, just ignore that. The frame sequence number is only available for
V4L2_EVENT_FRAME_SYNC events.


