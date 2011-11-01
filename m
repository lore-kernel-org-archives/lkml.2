Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab1KAM32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:29:28 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:39172 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab1KAM31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:29:27 -0400
Subject: Re: [PATCH][mm:] adjust the logic of checking THP
From: Paul Bolle <pebolle@tiscali.nl>
To: Guanjun He <heguanbo@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1320150365.14409.160.camel@x61.thuisdomein>
References: <shaohua.li@intel.com;linux-mm@kvack.org;linux-kernel@vger.kernel.org>
	 <1320147705-15117-1-git-send-email-heguanbo@gmail.com>
	 <1320150365.14409.160.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Nov 2011 13:29:23 +0100
Message-ID: <1320150563.14409.162.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-01 at 13:26 +0100, Paul Bolle wrote:
> Perhaps a summary would help the people actually knowledgeable about mm
> understand why this adjustment is needed

s/a summary/an explanation/


Paul Bolle

