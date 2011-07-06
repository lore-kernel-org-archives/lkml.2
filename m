Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1GFWuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 18:50:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751928Ab1GFWuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 18:50:18 -0400
Date: Wed, 6 Jul 2011 15:50:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Keng-Yu Lin <kengyu@canonical.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, gmane@colin.guthr.ie,
        Alessio Igor Bogani <abogani@texware.it>, stable@kernel.org
Subject: Re: [PATCH] Revert:
 "dell-laptop: Toggle the unsupported hardware killswitch"
Message-Id: <20110706155003.17090951.akpm@linux-foundation.org>
In-Reply-To: <1309169943-3786-1-git-send-email-kengyu@canonical.com>
References: <1309169943-3786-1-git-send-email-kengyu@canonical.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011 11:19:03 +0100
Keng-Yu Lin <kengyu@canonical.com> wrote:

> This reverts commit a3d77411e8b2ad661958c1fbee65beb476ec6d70,
> 
> as it causes a mess in the wireless rfkill status on some models.
> It is probably a bad idea to toggle the rfkill for all dell models
> without the respect to the claim that it is hardware-controlled.
> 

If we're reverting this from mainline then we should also revert it
from 2.6.38.x and 2.6.39.x, no?

