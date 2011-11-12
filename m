Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab1KLUk4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 15:40:56 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:37832 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab1KLUkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 15:40:55 -0500
Subject: Re: [PATCH] [TRIVIAL] drm: drop select of SLOW_WORK
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1320797810.14409.419.camel@x61.thuisdomein>
References: <1320797810.14409.419.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Nov 2011 21:40:52 +0100
Message-ID: <1321130452.27598.108.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 01:16 +0100, Paul Bolle wrote:
> slow-work got killed in commit 181a51f6e0. This means that since v2.6.36
> there is no Kconfig symbol SLOW_WORK. Apparently selecting that symbol
> is a nop. Drop that select.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

This one was taken by Dave Airlie and is already in the mainline tree. 


Paul Bolle

