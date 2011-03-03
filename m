Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657Ab1CCS7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 13:59:46 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61147 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758536Ab1CCS7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 13:59:45 -0500
MIME-Version: 1.0
In-Reply-To: <1297425606-13290-1-git-send-email-stigge@antcom.de>
References: <1297425606-13290-1-git-send-email-stigge@antcom.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 3 Mar 2011 11:59:25 -0700
X-Google-Sender-Auth: PHJ0wIHtzLWyUv_5kFfG-luGI_s
Message-ID: <AANLkTimUd1WQ2G0W0D0DLt+-bvdwxw9aZx6tgjno8ym=@mail.gmail.com>
Subject: Re: [PATCH] max730x: Added setup/teardown hooks
To: stigge@antcom.de
Cc: linux-kernel@vger.kernel.org, info@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 5:00 AM,  <stigge@antcom.de> wrote:
> max730x: Added setup/teardown hooks
>
> This patch adds setup and teardown hooks for configuration of GPIO lines via
> platform_data, similar to the pca953x driver.

Why?  What actions are these hooks going to perform?

g.
