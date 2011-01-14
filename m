Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab1ANWx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 17:53:27 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:53449 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752849Ab1ANWx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 17:53:26 -0500
MIME-Version: 1.0
In-Reply-To: <1294983293-10177-3-git-send-email-omar.ramirez@ti.com>
References: <1294983293-10177-1-git-send-email-omar.ramirez@ti.com>
	<1294983293-10177-3-git-send-email-omar.ramirez@ti.com>
Date: Fri, 14 Jan 2011 16:53:25 -0600
Message-ID: <AANLkTinG5tQJ=aFHJDcLJnWX7RF3Jjru_pUqXXn4=wue@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging: tidspbridge: replace mbox callback with notifier_call
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 11:34 PM, Omar Ramirez Luna <omar.ramirez@ti.com> wrote:
> Lately, mailbox callbacks have been replaced by notifier block
> call chains, this needs to be changed in the users of mailbox,
> otherwise compilation will break due to missing parameters.

Please hold on applying this patch, it is not right as io_mbx_msg
differs on what a notifier_call parameters and type should be.

Regards,

Omar
