Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab2EEKdb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 06:33:31 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:51147 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2EEKda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 06:33:30 -0400
Date: Sat, 5 May 2012 03:32:07 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] max17042_battery: Handle irq request failure case
Message-ID: <20120505103206.GA17706@lizard>
References: <1336173190-30003-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1336173190-30003-1-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 04:43:10AM +0530, Ramakrishna Pallala wrote:
> suspend/resume functions take action based upon the fuel gauge
> interrupt. If the rquest irq fails we should assign 0 to client->irq.
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> ---

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
