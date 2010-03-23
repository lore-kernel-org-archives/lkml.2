Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab0CWXyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 19:54:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39145 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab0CWXyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 19:54:50 -0400
X-Authority-Analysis: v=1.0 c=1 a=tHR7N9cJam8A:10 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=U-ItJb1p66ph-eKNiBcA:9 a=NsvVlzCl1dI39zkUr_yXwEi_zFUA:4 a=QEXdDO2ut3YA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 04/18] mac80211: Generate trace points only if api
 tracer enabled
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
In-Reply-To: <1269306693.7645.7.camel@jlt3.sipsolutions.net>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
	 <1269304340-25372-5-git-send-email-jack@suse.cz>
	 <1269306693.7645.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 19:54:46 -0400
Message-ID: <1269388486.5363.379.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-22 at 18:11 -0700, Johannes Berg wrote:
> On Tue, 2010-03-23 at 01:32 +0100, Jan Kara wrote:
> > CC: linux-wireless@vger.kernel.org
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> You kinda missed something there, this patch doesn't explain to me why
> and it's all I ever got to see :)

This patch set is about fine grained tuning of what tracepoints get
enabled and which don't. I honestly think that this should only be
permitted if CONFIG_EMBEDDED is set (if it should be permitted at all). 

I would much rather find a way to lower the tracepoint footprint than to
pick and choose what tracepoints get enabled.

-- Steve


