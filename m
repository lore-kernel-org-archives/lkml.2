Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab1AKDGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 22:06:37 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:45646 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab1AKDGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 22:06:30 -0500
Date: Tue, 11 Jan 2011 12:04:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Thomas Weber <weber@corscience.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers: video: Add modes for Devkit8000 displays
Message-ID: <20110111030425.GG3760@linux-sh.org>
References: <1294673672-30924-1-git-send-email-weber@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294673672-30924-1-git-send-email-weber@corscience.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 04:34:32PM +0100, Thomas Weber wrote:
> This patch adds the video modes for the 4.3, 5.6 and 7 inch panels that
> are sold with the devkit8000.
> 
> Signed-off-by: Thomas Weber <weber@corscience.de>

The modedb is primarily intended for generic modes that are going to be
used by a multiple of drivers. If you're simply dealing with modes for
panels for a one-off board that no one else is using, then simply keep it
local to the driver. If there are multiple users of the same modes, then
it's of course possible to make it generally available.
