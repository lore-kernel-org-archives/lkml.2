Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab0LMIor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 03:44:47 -0500
Received: from cantor.suse.de ([195.135.220.2]:54292 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab0LMIoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 03:44:46 -0500
From: David Sterba <dsterba@suse.cz>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 21/30] pcmcia/ipwireless: don't use flush_scheduled_work()
Date: Mon, 13 Dec 2010 09:44:43 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
References: <1292086307-19211-1-git-send-email-tj@kernel.org> <1292086307-19211-22-git-send-email-tj@kernel.org>
In-Reply-To: <1292086307-19211-22-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201012130944.44424.dsterba@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 December 2010 17:51:38 Tejun Heo wrote:
> flush_scheduled_work() is deprecated and scheduled to be removed.
> Directly flush the used works instead.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: David Sterba <dsterba@suse.cz>

Acked-by: David Sterba <dsterba@suse.cz>


Dave
