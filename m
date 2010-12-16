Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab0LPVu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 16:50:27 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43295 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab0LPVu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 16:50:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=JkuiBYxqDnLniRGOoykZusVvtOkLLBOneEmA+wm10c6eIZjdvJ1zLhsph4V6AQb8hV
         sckIdkXTeXN02gWpfpHp8274a0D/KigP6wzsrmR5IcC3TwP1vK+NUi4XgT6K3ccUAf6t
         XUHiQ3haKGN6zMor7n8N+rFAusW6b75MddRNQ=
From: Francis Moreau <francis.moro@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Why not making tools/* git submodules ?
Date: Thu, 16 Dec 2010 22:50:21 +0100
Message-ID: <m27hf9crqa.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm just wondering if all tools could be tracked using git submodule.

That would allow the tools to have their own tags at least.

Thanks
-- 
Francis
