Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab2CZQeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 12:34:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64392 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610Ab2CZQeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 12:34:08 -0400
Date: Mon, 26 Mar 2012 20:33:01 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] max17042_battery: Clean up interrupt handling
Message-ID: <20120326163301.GA19623@lizard>
References: <1332279196-17991-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1332279196-17991-1-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 03:03:16AM +0530, Ramakrishna Pallala wrote:
> Max17042 driver has dummy hardIRQ function which
> does nothing but waking the threaded handler.
> 
> This patch removes the hardIRQ function and also
> modifies the interrupt type to falling edge. While
> we are there, change the macros to comply with the
> Data sheet.
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> ---

Applied, thank you!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
