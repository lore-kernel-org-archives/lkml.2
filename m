Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422713Ab2CPLQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 07:16:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965483Ab2CPLQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 07:16:42 -0400
Date: Fri, 16 Mar 2012 12:16:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Przemo Firszt <przemo@firszt.eu>
Cc: pinglinux@gmail.com, chris@cnpbagwell.com, killertofu@gmail.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/2] HID: wacom: Replace __set_bit with
 input_set_capability
In-Reply-To: <1331754904-8927-1-git-send-email-przemo@firszt.eu>
Message-ID: <alpine.LNX.2.00.1203161216200.18356@pobox.suse.cz>
References: <1331754904-8927-1-git-send-email-przemo@firszt.eu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2012, Przemo Firszt wrote:

> It's a trivial patch. It's doesn't change the functionality as the helper
> input_set_capability does the same thing.
> 
> Signed-off-by: Przemo Firszt <przemo@firszt.eu>

Both patches applied, thanks.

-- 
Jiri Kosina
SUSE Labs
