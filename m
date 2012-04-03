Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab2DCCNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:13:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab2DCCNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:13:38 -0400
Date: Tue, 3 Apr 2012 04:13:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Simon Wood <simon@mungewell.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Bauer <michael@m-bauer.org>,
        Michal Maly <madcatxster@gmail.com>
Subject: Re: [PATCH 1/2] HID: hid-lg4ff: Use Private Data
In-Reply-To: <1333378444-3117-1-git-send-email-simon@mungewell.org>
Message-ID: <alpine.LNX.2.00.1204030413030.16928@pobox.suse.cz>
References: <a4e40aa5c43be934d83240849aa25f3b.squirrel@mungewell.org> <1333378444-3117-1-git-send-email-simon@mungewell.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2012, Simon Wood wrote:

> Use private data in hid-lg4ff to store device properties.

I'd like to have a more verbose changelog -- namely what advantage this 
brings compared to the previous state.

Thanks.

-- 
Jiri Kosina
SUSE Labs
