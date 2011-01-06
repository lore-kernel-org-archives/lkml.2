Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1AFP5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:57:32 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:49583 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab1AFP5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:57:30 -0500
X-Greylist: delayed 1721 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jan 2011 10:57:30 EST
From: Ferenc Wagner <wferi@niif.hu>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, wferi@niif.hu
Subject: Re: [PATCH 2/2] Replace the dangerous to_root_device macro with an inline function
References: <44482f820e5700f952825c9b5ec6a9f080975d79.1294326889.git.wferi@niif.hu>
Date: Thu, 06 Jan 2011 16:28:45 +0100
In-Reply-To: <44482f820e5700f952825c9b5ec6a9f080975d79.1294326889.git.wferi@niif.hu>
	(Ferenc Wagner's message of "Thu, 6 Jan 2011 16:24:24 +0100")
Message-ID: <877hei3vbm.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the misleading 2/2 subject tag, this is a solitary patch.
-- 
Regards,
Feri.
