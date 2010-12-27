Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab0L0Pdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 10:33:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088Ab0L0Pdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 10:33:49 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-input@vger.kernel.org
Subject: Re: [PATCH 1/3] HID: picolcd: fix misuse of logical operation in place of bitop
Date: Mon, 27 Dec 2010 16:33:45 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org,
        Bruno =?utf-8?q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Jiri Kosina <jkosina@suse.cz>
References: <1293463663-21198-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1293463663-21198-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201012271633.46978.dsterba@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 December 2010 16:27:43 David Sterba wrote:
> Re: [PATCH 1/3]
             ^^^
sorry, I forgot to give --no-numbered to format-patch, this is just one patch,

dave
