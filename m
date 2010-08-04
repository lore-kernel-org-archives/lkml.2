Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab0HDNWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 09:22:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:49812 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757820Ab0HDNWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 09:22:39 -0400
Date: Wed, 4 Aug 2010 15:22:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Weber <weber@corscience.de>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Paulo Marques <pmarques@grupopie.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH]Documentation update broken web addresses.
In-Reply-To: <4C547464.6000505@gmail.com>
Message-ID: <alpine.LNX.2.00.1008041521480.29919@pobox.suse.cz>
References: <1279943484-31069-1-git-send-email-justinmattock@gmail.com> <4C547464.6000505@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jul 2010, Justin P. Mattock wrote:

> any ideas on the status of this?

I have now applied it. Please keep in mind, for your future submissions, 
to make sure that you handle UTF-8 correctly. I had to manually fix your 
patch for files in Japaneese, Korean and Chineese languages.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
