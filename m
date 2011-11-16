Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab1KPLzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:55:03 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34340 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab1KPLzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:55:00 -0500
Date: Wed, 16 Nov 2011 15:54:55 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Rob Herring <rob.herring@calxeda.com>,
        Richard Zhu <richard.zhu@linaro.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci_platform: fix DT probing
Message-ID: <20111116115455.GB21448@oksana.dev.rtsoft.ru>
References: <1321412456-31107-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1321412456-31107-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 09:00:56PM -0600, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> The change in commit 904c04feaf13ed "ahci_platform: Add the board_ids..."
> doesn't work for the DT probing case as platform_get_device_id returns
> NULL. Pick the default ahci_port_info in this case.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Richard Zhu <richard.zhu@linaro.org>
> Cc: Anton Vorontsov <avorontsov@mvista.com>
> Cc: Jeff Garzik <jgarzik@pobox.com>
> Cc: linux-ide@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
