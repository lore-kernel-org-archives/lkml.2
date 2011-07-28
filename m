Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab1G1WKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 18:10:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44440 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab1G1WKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 18:10:40 -0400
MIME-Version: 1.0
In-Reply-To: <4E271B72.3070909@gmx.de>
References: <4DF7B0B4.4060002@gmx.de>
	<1308337359-3480-1-git-send-email-FlorianSchandinat@gmx.de>
	<4E271B72.3070909@gmx.de>
Date: Fri, 29 Jul 2011 00:10:36 +0200
Message-ID: <CAC9WiBidzYhuZMDS4VZpE7cTUdF0_NcAXFwEfCduKzge1CA4mw@mail.gmail.com>
Subject: Re: [PATCH] fb: avoid possible deadlock caused by fb_set_suspend
From: Francis Moreau <francis.moro@gmail.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: lethal@linux-sh.org, linux-fbdev@vger.kernel.org,
        torvalds@linux-foundation.org, bonbons@linux-vserver.org,
        linux-kernel@vger.kernel.org,
        Herton Ronaldo Krzesinski <herton@mandriva.com.br>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 8:16 PM, Florian Tobias Schandinat
<FlorianSchandinat@gmx.de> wrote:
> what are your plans for the patch below? Do you queue it for 3.1?

Looks like someone else fixed it slightly differently:

http://permalink.gmane.org/gmane.linux.kernel.stable/15187

-- 
Francis
