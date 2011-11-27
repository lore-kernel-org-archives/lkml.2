Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab1K0PqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 10:46:15 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59385 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab1K0PqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 10:46:14 -0500
MIME-Version: 1.0
In-Reply-To: <20111127010700.GA1037@kroah.com>
References: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
	<20111127010700.GA1037@kroah.com>
Date: Sun, 27 Nov 2011 16:46:13 +0100
Message-ID: <CAMeQTsaAoTGc=femSjkrXDfXiLH892UGgVG88HREzOna5YtF+g@mail.gmail.com>
Subject: Re: [PATCH 0/9] Split psb_intel_output to encoders and connectors
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 2:07 AM, Greg KH <greg@kroah.com> wrote:
> I need an ack from Alan before I can take this series.

I have talked to Alan and this will not go into staging. Alan is moving gma500
out of staging so I will adapt my patches to drm-next instead.

Thanks
Patrik
